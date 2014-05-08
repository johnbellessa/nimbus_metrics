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
    end
  end

  def load_topologies
    all_topology_ids = Set.new
    all_topology_names = {} 
    topologies = @client.getClusterInfo.topologies
    topologies.each do |top|
      # add the topology unless it begins with an underscore
      all_topology_ids.add(top.id) unless top.name[0].include? '_'
      all_topology_names[top.id] = top.name unless top.name[0].include? '_'
    end
    new_tops = all_topology_ids - @topology_ids
    @new_topologies = []
    new_tops.each do | new_top |
      topology = Topology.new(self, new_top, all_topology_names[new_top])
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
  attr_reader :name
  def initialize(cluster, topology_id, name)
    @cluster = Cluster.new($nimbus_host_ip)
    @id = topology_id
    @name = name 
    @csv_files = {
      'capacity' =>  {}, 
      'emit_rate' => {}, 
      'process_latency' => {}, 
      'execute_latency' => {}, 
    }
    mkdir_output = `mkdir -p #{$output_dir}/#{@name}/results`
    puts mkdir_output if mkdir_output.length > 0
    @csv_files.each do |metric, dict|
      filename = "#{$output_dir}/#{@name}/results/#{@name}__#{metric}.csv"
      dict['filename'] = filename
    end
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
        @csv_files.each do |metric, file_info| 
          file_info['file'].flush unless file_info['file'].nil?
        end
        #@csv.flush unless @csv.nil?
        @emit_csv.flush unless @emit_csv.nil?
        sleep(query_time)
      end
    rescue SystemExit, Interrupt
      close_top
    end
  end

  def close_top 
    @cluster.close
    @csv_files.each do |metric, file_info| 
        puts "Closing file for: #{@name} - #{metric}"
        file_info['file'].close() unless file_info['file'].nil?
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

  def calculate_latency
    @process_latency = {} 
    @execute_latency = {}
    @bolts.each do |component, executors| 
      avg_process = 0
      process_count = 0
      avg_execute = 0
      exec_count = 0
      executors.each do |summary|
        latency = summary.stats.specific.bolt.execute_ms_avg['600'].values[0]
        process_ms_avg = summary.stats.specific.bolt.process_ms_avg['600'].values[0]
        execute_ms_avg = summary.stats.specific.bolt.execute_ms_avg['600'].values[0]
        unless process_ms_avg.nil? || process_ms_avg.to_f < 0.01
          avg_process += process_ms_avg         
          process_count += 1
        end
        unless execute_ms_avg.nil? || execute_ms_avg.to_f < 0.01 
          avg_execute += execute_ms_avg 
          exec_count += 1
        end
      end
      avg_process /= process_count unless process_count == 0
      avg_execute /= exec_count unless exec_count == 0
      @process_latency[component] = avg_process
      @execute_latency[component] = avg_execute
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

    end
  end


  def emit_and_capacity_metric
    emit_rate_metric
    categorize_executors
    calculate_capacity

    # capacity to csv
    csv_wrapper('capacity', @bolt_capacity.keys.sort_by{ |key| key }, @bolt_capacity)

    # emit rate to csv
    unless @rates.nil?
      csv_wrapper('emit_rate', @rates.keys, @rates)
    end

    calculate_latency
    csv_wrapper('process_latency', @process_latency.keys, @process_latency)
    csv_wrapper('execute_latency', @execute_latency.keys, @execute_latency)
  end

  def csv_wrapper(metric, keys, values)
    if @csv_files[metric]['file'].nil?
      puts "Creating CSV file: #{@csv_files[metric]['filename']}"
      @csv_files[metric]['file'] = CSV.open(@csv_files[metric]['filename'], "wb")
      @csv_files[metric]['file'] << keys
    else
      output = []
      keys.each do |key|
        output << values[key]
      end
      @csv_files[metric]['file'] << output
      @csv_files[metric]['file'].flush
    end
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
    begin
      while true do
        @cluster.load_topologies
        if @cluster.new_topologies?
          puts "Loading threads for new topologies"
          load_threads
        end
        sleep(10)
      end
    rescue SystemExit, Interrupt
      @threads.each do |thread| 
        thread.exit
      end
    end
  end

  def load_threads
    @cluster.new_topologies.each do |top|
      t = Thread.new {
        counter = 0
        top.run(@query_time) do
          begin
            top.emit_and_capacity_metric
            # added 1 since the first round doesn't output to the emit csv
            if counter >= ((60 * @run_time) / @query_time) + 1 
              puts "Thread for #{@name} exiting"
              top.close_top
              Thread.exit
            end
            counter += 1
          rescue StandardError => e
            PP.pp e
            Thread.exit
          end
        end
      }
      @threads << t
    end
  end

end

storm_yaml = YAML.load_file(ENV['HOME'] + '/.storm/storm.yaml')
$nimbus_host_ip =  storm_yaml['nimbus.host']
cluster = Cluster.new($nimbus_host_ip)
query_time =  (ARGV[0].to_i unless ARGV[0].nil?) || 5 
run_time = (ARGV[1].to_f unless ARGV[1].nil?) || 0.5 
$output_dir = ARGV[2] || './runs'
metrics = Metrics.new(cluster, query_time, run_time)
metrics.run
