#!/usr/bin/env ruby

$:.push('gen-rb')

require 'thrift'
require 'nimbus'
require 'json'
require 'pp'
require 'yaml'
require 'csv'
require 'set'
require 'yaml'

class Cluster
  attr_reader :client
  attr_reader :topologies
  attr_reader :new_topologies

  def initialize nimbus_ip
    @topology_ids = Set.new
    @topologies = []
    error_wrapper do
      socket = Thrift::Socket.new(nimbus_ip, 6627)
      @transport = Thrift::FramedTransport.new(socket)
      protocol = Thrift::BinaryProtocol.new(@transport)
      @client = Nimbus::Client.new(protocol)
      @transport.open
      #PP.pp @client.getClusterInfo.topologies[0].methods
    end
  end

  def load_topologies
    puts "Loading Topologies"
    all_topologies = Set.new
    topologies = @client.getClusterInfo.topologies
    topologies.each do |top|
      all_topologies.add(top.id)
    end
    new_tops = all_topologies - @topology_ids
    @new_topologies = []
    new_tops.each do | new_top |
      topology = Topology.new(self, new_top)
      @topologies << topology
      @new_topologies << topology
      @topology_ids << new_top
    end
    puts "New Topology(ies) found" unless @new_topologies.empty?
  end

  def new_topologies?
    if @new_topologies.empty?
      false
    else
      true
    end
  end

  def error_wrapper
    begin
      yield
    rescue Thrift::Exception => tx
      print 'Thrift::Exception: ', tx.message, "\n"
      print 'Thrift::Exception: ', tx, "\n"
    end
  end

  def get_executors topology_id
    error_wrapper do
      @client.getTopologyInfo(topology_id).executors
    end
  end

  def close
    error_wrapper do
      @transport.close
    end
  end
end

class Topology
  def initialize cluster, topology_id
    @cluster = cluster
    @id = topology_id
  end

  def load_executors
    # loads with timestamp
    @last_loaded_at = Time.now
    @executors = @cluster.get_executors @id
  end

  def uptime_secs
    @cluster.client.getTopologyInfo(@id).uptime_secs
  end

  def categorize_executors
    @bolts = {}
    @spouts = {}
    @executors.each do |e|
      #PP.pp e.methods
      #PP.pp "Port: #{e.executor_info.task_end}"
      if e.stats
        if e.stats.specific != nil
          if e.stats.specific.bolt?
            if @bolts[e.component_id].nil?
              @bolts[e.component_id] = [e]
            else
              @bolts[e.component_id] << e
            end
          elsif e.stats.specific.spout?
            if @spouts[e.component_id].nil?
              @spouts[e.component_id] = [e]
            else
              @spouts[e.component_id] << e
            end
          end
        end
      end
    end
  end

  def calculate_capacity
    # This is calculating per bolt capacity

    ### BOLT CAPACITY CALCULATION (BASED ON CLOJURE CODE)
    @bolt_capacity = {}
    @bolts.each do |component, executors|
      #puts component
      highest_cap = 0
      window = 0
      executors.each do |summary|
        executed = summary.stats.specific.bolt.executed['600'].values[0]
        if self.uptime_secs > 600
          window = 600 
        else
          window = self.uptime_secs
        end
        latency = summary.stats.specific.bolt.execute_ms_avg['600'].values[0]
        unless executed.nil? or latency.nil?
          capacity = (executed * latency) / (1000 * window)
          if capacity > highest_cap
            highest_cap = capacity
          end
        end
      end
      @bolt_capacity[component] = highest_cap
    end
  end

  def run query_time
    @query_time = query_time
    begin
      while true
        yield
        @csv.flush unless @csv.nil?
        @emit_csv.flush unless @emit_csv.nil?
        sleep(query_time)
      end
    rescue SystemExit, Interrupt
      @cluster.close
      @csv.close() unless @csv.nil?
      @emit_csv.close() unless @emit_csv.nil?
      puts
    end
  end

  def capacity_metric
    load_executors
    categorize_executors
    calculate_capacity
    PP.pp @bolt_capacity
  end

  def computed_total_emitted
    @total_emitted = {}
    elements = @bolts.merge(@spouts)
    elements.each do |component, executors|
      #puts component
      @total_emitted[component] = 0
      executors.each do |summary|
        emitted = summary.stats.emitted[':all-time']['default']
        @total_emitted[component] += emitted unless emitted.nil?
      end
    end
  end


  def computed_total_acked
    @total_acked = {}
    elements = @bolts.merge(@spouts)
    elements.each do |component, executors|
      #puts component
      @total_emitted[component] = 0
      executors.each do |summary|
        emitted = summary.stats.emitted[':all-time']['default']
        @total_emitted[component] += emitted unless emitted.nil?
      end
    end
  end

  def compute_diffs(old_totals, new_totals)
    @total_diffs = {}
    old_totals.each do |component_id, old_total|
      @total_diffs[component_id] = new_totals[component_id] - old_total
    end
  end

  def compute_rate(old_time)
    @rates = {}
    @total_diffs.each do |component, diff|
      # NOTE: Time diff in milli seconds
      @rates[component] = diff / ((@last_loaded_at - old_time)).to_i
    end
  end

  def emit_rate_metric
    if @total_emitted.nil?
      load_executors
      categorize_executors
      computed_total_emitted
    else
      # save old time and old totals
      old_time = @last_loaded_at
      old_totals = @total_emitted

      # Reload executors
      load_executors

      # categorize into spouts and bolts
      categorize_executors

      # compute new totals per spout/bolt
      computed_total_emitted
      new_totals = @total_emitted

      # diff them
      compute_diffs(old_totals, new_totals)
      # get rate
      compute_rate(old_time)

      PP.pp @rates
    end
  end


  def emit_and_capacity_metric
    emit_rate_metric
    categorize_executors
    calculate_capacity
    #PP.pp @bolt_capacity
    #puts '=================================='
    yaml_out = {
        'capacity' => @bolt_capacity,
        'emit_rate' => @rates
    }.to_yaml

    if @csv.nil?
      @csv = CSV.open("./results/#{@id}_capacity.csv", "wb")
      @keys = @bolt_capacity.keys.sort_by { |key| key }
      @csv << @keys
    else
      output = []
      (@keys.sort_by{ |key| key}).each do |key|
        output << @bolt_capacity[key]
      end
      @csv << output
    end

    unless @rates.nil?
      if @emit_csv.nil?
        @emit_csv = CSV.open("./results/#{@id}_emit_rate.csv", "wb")
        @keys_emit = @rates.keys
        @emit_csv << @keys_emit
      else
        output = []
        @keys_emit.each do |key|
          output << @rates[key]
        end
        @emit_csv << output
      end
    end
    puts yaml_out unless @rates.nil?
  end


  def ack_rate_metric
    if @total_acked.nil?
      load_executors
      categorize_executors
      computed_total_acked
    else
      # save old time and old totals
      old_time = @last_loaded_at
      old_totals = @total_acked

      # Reload executors
      load_executors

      # categorize into spouts and bolts
      categorize_executors

      # compute new totals per spout/bolt
      computed_total_acked
      new_totals = @total_acked

      # diff them
      compute_diffs(old_totals, new_totals)
      # get rate
      compute_rate(old_time)

      PP.pp @rates
    end
  end
end

class Metrics
  def initialize(cluster, query_time, run_time)
    @cluster = cluster
    @query_time = query_time
    @run_time = run_time
    @threads = []
  end

  def run
    while true do
      @cluster.load_topologies
      if @cluster.new_topologies?
        puts "Loading threads for new topologies"
        load_threads
      end
      sleep(10)
    end
  end

  def load_threads
    @cluster.new_topologies.each do |top|
      t = Thread.new {
        top.run(@query_time) do
          counter = 0
          top.emit_and_capacity_metric
          counter += 1
          # added 1 since the first round doesn't output to the emit csv
          if counter == ((60 * @run_time) / @query_time) + 1
            Thread.exit
          end
        end
      }
      @threads << t
    end
  end

end

storm_yaml = YAML.load_file(ENV['HOME'] + '/.storm/storm.yaml')
nimbus_host_ip =  storm_yaml['nimbus.host']
cluster = Cluster.new(nimbus_host_ip)
query_time =  ARGV[0].to_i
run_time = ARGV[1].to_i
metrics = Metrics.new(cluster, query_time, run_time)
metrics.run
