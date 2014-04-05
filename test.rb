$:.push('gen-rb')

require 'thrift'
require 'nimbus'
require 'json'
require 'pp'

class Cluster
  def initialize nimbus_ip
    socket = Thrift::Socket.new(nimbus_ip, 6627)
    transport = Thrift::FramedTransport.new(socket)
    protocol = Thrift::BinaryProtocol.new(transport)
    client = Nimbus::Client.new(protocol)
    transport.open
  end

  def error_wrapper
    begin
      yield
    rescue Thrift::Exception => tx
      print 'Thrift::Exception: ', tx.message, "\n"
      print 'Thrift::Exception: ', tx, "\n"    end
  end
end

begin
  ID = 'ReadsTopology3-6-1396662055'
  socket = Thrift::Socket.new('172.22.138.204', 6627)
  transport = Thrift::FramedTransport.new(socket)
  protocol = Thrift::BinaryProtocol.new(transport)
  client = Nimbus::Client.new(protocol)
  transport.open
  topology = client.getTopology(ID)
  #PP.pp topology.spouts
  summary = client.getClusterInfo
  #PP.pp summary.inspect
  #PP.pp summary.topologies[0]
  #puts 'Topology Info'
  #PP.pp client.getTopologyInfo(ID)#.executors[5].methods
  #puts '================================'

  topInfo = client.getTopologyInfo(ID)
  executors = topInfo.executors

  bolts = {}
  spouts = {}
  executors.each do |e|
    if e.stats.specific.bolt?
      if bolts[e.component_id].nil?
        bolts[e.component_id] = [e]
      else
        bolts[e.component_id] << e
      end
    elsif e.stats.specific.spout?
      if spouts[e.component_id].nil?
        spouts[e.component_id] = [e]
      else
        spouts[e.component_id] << e
      end
    end
  end

  ### BOLT CAPACITY CALCULATION (BASED ON CLOJURE CODE)
  bolt_capacity = {}
  bolts.each do |component, executors|
    puts component
    highest_cap = 0
    executors.each do |summary|
      executed = summary.stats.specific.bolt.executed['600'].values[0]
      window = 600
      latency = summary.stats.specific.bolt.execute_ms_avg['600'].values[0]
      unless executed.nil? or latency.nil?
        capacity = (executed * latency) / (1000 * window)
        if capacity > highest_cap
          highest_cap = capacity
        end
      end
    end
    bolt_capacity[component] = highest_cap
  end
  PP.pp bolt_capacity

  bolt_emitted_10m = {}
  bolts.each do |component, executors|
    puts component
    executors.each do |summary|
      #PP.pp summary.stats#.emitted['600'].values[0]
    end
  end

  while true
    PP.pp executors[10].stats
    sleep(5)
  end

  #PP.pp summary.topologies[0].methods
  #PP.pp JSON::parse client.getTopologyConf('ReadsTopology-3-1396567174')#.executors[5].methods
  transport.close
rescue Thrift::Exception => tx
  print 'Thrift::Exception: ', tx.message, "\n"
  print 'Thrift::Exception: ', tx, "\n"
end
