#
# Autogenerated by Thrift Compiler (0.9.1)
#
# DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
#

require 'thrift'
require 'storm_types'

module Nimbus
  class Client
    include ::Thrift::Client

    def submitTopology(name, uploadedJarLocation, jsonConf, topology)
      send_submitTopology(name, uploadedJarLocation, jsonConf, topology)
      recv_submitTopology()
    end

    def send_submitTopology(name, uploadedJarLocation, jsonConf, topology)
      send_message('submitTopology', SubmitTopology_args, :name => name, :uploadedJarLocation => uploadedJarLocation, :jsonConf => jsonConf, :topology => topology)
    end

    def recv_submitTopology()
      result = receive_message(SubmitTopology_result)
      raise result.e unless result.e.nil?
      raise result.ite unless result.ite.nil?
      return
    end

    def submitTopologyWithOpts(name, uploadedJarLocation, jsonConf, topology, options)
      send_submitTopologyWithOpts(name, uploadedJarLocation, jsonConf, topology, options)
      recv_submitTopologyWithOpts()
    end

    def send_submitTopologyWithOpts(name, uploadedJarLocation, jsonConf, topology, options)
      send_message('submitTopologyWithOpts', SubmitTopologyWithOpts_args, :name => name, :uploadedJarLocation => uploadedJarLocation, :jsonConf => jsonConf, :topology => topology, :options => options)
    end

    def recv_submitTopologyWithOpts()
      result = receive_message(SubmitTopologyWithOpts_result)
      raise result.e unless result.e.nil?
      raise result.ite unless result.ite.nil?
      return
    end

    def killTopology(name)
      send_killTopology(name)
      recv_killTopology()
    end

    def send_killTopology(name)
      send_message('killTopology', KillTopology_args, :name => name)
    end

    def recv_killTopology()
      result = receive_message(KillTopology_result)
      raise result.e unless result.e.nil?
      return
    end

    def killTopologyWithOpts(name, options)
      send_killTopologyWithOpts(name, options)
      recv_killTopologyWithOpts()
    end

    def send_killTopologyWithOpts(name, options)
      send_message('killTopologyWithOpts', KillTopologyWithOpts_args, :name => name, :options => options)
    end

    def recv_killTopologyWithOpts()
      result = receive_message(KillTopologyWithOpts_result)
      raise result.e unless result.e.nil?
      return
    end

    def activate(name)
      send_activate(name)
      recv_activate()
    end

    def send_activate(name)
      send_message('activate', Activate_args, :name => name)
    end

    def recv_activate()
      result = receive_message(Activate_result)
      raise result.e unless result.e.nil?
      return
    end

    def deactivate(name)
      send_deactivate(name)
      recv_deactivate()
    end

    def send_deactivate(name)
      send_message('deactivate', Deactivate_args, :name => name)
    end

    def recv_deactivate()
      result = receive_message(Deactivate_result)
      raise result.e unless result.e.nil?
      return
    end

    def rebalance(name, options)
      send_rebalance(name, options)
      recv_rebalance()
    end

    def send_rebalance(name, options)
      send_message('rebalance', Rebalance_args, :name => name, :options => options)
    end

    def recv_rebalance()
      result = receive_message(Rebalance_result)
      raise result.e unless result.e.nil?
      raise result.ite unless result.ite.nil?
      return
    end

    def beginFileUpload()
      send_beginFileUpload()
      return recv_beginFileUpload()
    end

    def send_beginFileUpload()
      send_message('beginFileUpload', BeginFileUpload_args)
    end

    def recv_beginFileUpload()
      result = receive_message(BeginFileUpload_result)
      return result.success unless result.success.nil?
      raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'beginFileUpload failed: unknown result')
    end

    def uploadChunk(location, chunk)
      send_uploadChunk(location, chunk)
      recv_uploadChunk()
    end

    def send_uploadChunk(location, chunk)
      send_message('uploadChunk', UploadChunk_args, :location => location, :chunk => chunk)
    end

    def recv_uploadChunk()
      result = receive_message(UploadChunk_result)
      return
    end

    def finishFileUpload(location)
      send_finishFileUpload(location)
      recv_finishFileUpload()
    end

    def send_finishFileUpload(location)
      send_message('finishFileUpload', FinishFileUpload_args, :location => location)
    end

    def recv_finishFileUpload()
      result = receive_message(FinishFileUpload_result)
      return
    end

    def beginFileDownload(file)
      send_beginFileDownload(file)
      return recv_beginFileDownload()
    end

    def send_beginFileDownload(file)
      send_message('beginFileDownload', BeginFileDownload_args, :file => file)
    end

    def recv_beginFileDownload()
      result = receive_message(BeginFileDownload_result)
      return result.success unless result.success.nil?
      raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'beginFileDownload failed: unknown result')
    end

    def downloadChunk(id)
      send_downloadChunk(id)
      return recv_downloadChunk()
    end

    def send_downloadChunk(id)
      send_message('downloadChunk', DownloadChunk_args, :id => id)
    end

    def recv_downloadChunk()
      result = receive_message(DownloadChunk_result)
      return result.success unless result.success.nil?
      raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'downloadChunk failed: unknown result')
    end

    def getNimbusConf()
      send_getNimbusConf()
      return recv_getNimbusConf()
    end

    def send_getNimbusConf()
      send_message('getNimbusConf', GetNimbusConf_args)
    end

    def recv_getNimbusConf()
      result = receive_message(GetNimbusConf_result)
      return result.success unless result.success.nil?
      raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'getNimbusConf failed: unknown result')
    end

    def getClusterInfo()
      send_getClusterInfo()
      return recv_getClusterInfo()
    end

    def send_getClusterInfo()
      send_message('getClusterInfo', GetClusterInfo_args)
    end

    def recv_getClusterInfo()
      result = receive_message(GetClusterInfo_result)
      return result.success unless result.success.nil?
      raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'getClusterInfo failed: unknown result')
    end

    def getTopologyInfo(id)
      send_getTopologyInfo(id)
      return recv_getTopologyInfo()
    end

    def send_getTopologyInfo(id)
      send_message('getTopologyInfo', GetTopologyInfo_args, :id => id)
    end

    def recv_getTopologyInfo()
      result = receive_message(GetTopologyInfo_result)
      return result.success unless result.success.nil?
      raise result.e unless result.e.nil?
      raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'getTopologyInfo failed: unknown result')
    end

    def getTopologyConf(id)
      send_getTopologyConf(id)
      return recv_getTopologyConf()
    end

    def send_getTopologyConf(id)
      send_message('getTopologyConf', GetTopologyConf_args, :id => id)
    end

    def recv_getTopologyConf()
      result = receive_message(GetTopologyConf_result)
      return result.success unless result.success.nil?
      raise result.e unless result.e.nil?
      raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'getTopologyConf failed: unknown result')
    end

    def getTopology(id)
      send_getTopology(id)
      return recv_getTopology()
    end

    def send_getTopology(id)
      send_message('getTopology', GetTopology_args, :id => id)
    end

    def recv_getTopology()
      result = receive_message(GetTopology_result)
      return result.success unless result.success.nil?
      raise result.e unless result.e.nil?
      raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'getTopology failed: unknown result')
    end

    def getUserTopology(id)
      send_getUserTopology(id)
      return recv_getUserTopology()
    end

    def send_getUserTopology(id)
      send_message('getUserTopology', GetUserTopology_args, :id => id)
    end

    def recv_getUserTopology()
      result = receive_message(GetUserTopology_result)
      return result.success unless result.success.nil?
      raise result.e unless result.e.nil?
      raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'getUserTopology failed: unknown result')
    end

  end

  class Processor
    include ::Thrift::Processor

    def process_submitTopology(seqid, iprot, oprot)
      args = read_args(iprot, SubmitTopology_args)
      result = SubmitTopology_result.new()
      begin
        @handler.submitTopology(args.name, args.uploadedJarLocation, args.jsonConf, args.topology)
      rescue ::AlreadyAliveException => e
        result.e = e
      rescue ::InvalidTopologyException => ite
        result.ite = ite
      end
      write_result(result, oprot, 'submitTopology', seqid)
    end

    def process_submitTopologyWithOpts(seqid, iprot, oprot)
      args = read_args(iprot, SubmitTopologyWithOpts_args)
      result = SubmitTopologyWithOpts_result.new()
      begin
        @handler.submitTopologyWithOpts(args.name, args.uploadedJarLocation, args.jsonConf, args.topology, args.options)
      rescue ::AlreadyAliveException => e
        result.e = e
      rescue ::InvalidTopologyException => ite
        result.ite = ite
      end
      write_result(result, oprot, 'submitTopologyWithOpts', seqid)
    end

    def process_killTopology(seqid, iprot, oprot)
      args = read_args(iprot, KillTopology_args)
      result = KillTopology_result.new()
      begin
        @handler.killTopology(args.name)
      rescue ::NotAliveException => e
        result.e = e
      end
      write_result(result, oprot, 'killTopology', seqid)
    end

    def process_killTopologyWithOpts(seqid, iprot, oprot)
      args = read_args(iprot, KillTopologyWithOpts_args)
      result = KillTopologyWithOpts_result.new()
      begin
        @handler.killTopologyWithOpts(args.name, args.options)
      rescue ::NotAliveException => e
        result.e = e
      end
      write_result(result, oprot, 'killTopologyWithOpts', seqid)
    end

    def process_activate(seqid, iprot, oprot)
      args = read_args(iprot, Activate_args)
      result = Activate_result.new()
      begin
        @handler.activate(args.name)
      rescue ::NotAliveException => e
        result.e = e
      end
      write_result(result, oprot, 'activate', seqid)
    end

    def process_deactivate(seqid, iprot, oprot)
      args = read_args(iprot, Deactivate_args)
      result = Deactivate_result.new()
      begin
        @handler.deactivate(args.name)
      rescue ::NotAliveException => e
        result.e = e
      end
      write_result(result, oprot, 'deactivate', seqid)
    end

    def process_rebalance(seqid, iprot, oprot)
      args = read_args(iprot, Rebalance_args)
      result = Rebalance_result.new()
      begin
        @handler.rebalance(args.name, args.options)
      rescue ::NotAliveException => e
        result.e = e
      rescue ::InvalidTopologyException => ite
        result.ite = ite
      end
      write_result(result, oprot, 'rebalance', seqid)
    end

    def process_beginFileUpload(seqid, iprot, oprot)
      args = read_args(iprot, BeginFileUpload_args)
      result = BeginFileUpload_result.new()
      result.success = @handler.beginFileUpload()
      write_result(result, oprot, 'beginFileUpload', seqid)
    end

    def process_uploadChunk(seqid, iprot, oprot)
      args = read_args(iprot, UploadChunk_args)
      result = UploadChunk_result.new()
      @handler.uploadChunk(args.location, args.chunk)
      write_result(result, oprot, 'uploadChunk', seqid)
    end

    def process_finishFileUpload(seqid, iprot, oprot)
      args = read_args(iprot, FinishFileUpload_args)
      result = FinishFileUpload_result.new()
      @handler.finishFileUpload(args.location)
      write_result(result, oprot, 'finishFileUpload', seqid)
    end

    def process_beginFileDownload(seqid, iprot, oprot)
      args = read_args(iprot, BeginFileDownload_args)
      result = BeginFileDownload_result.new()
      result.success = @handler.beginFileDownload(args.file)
      write_result(result, oprot, 'beginFileDownload', seqid)
    end

    def process_downloadChunk(seqid, iprot, oprot)
      args = read_args(iprot, DownloadChunk_args)
      result = DownloadChunk_result.new()
      result.success = @handler.downloadChunk(args.id)
      write_result(result, oprot, 'downloadChunk', seqid)
    end

    def process_getNimbusConf(seqid, iprot, oprot)
      args = read_args(iprot, GetNimbusConf_args)
      result = GetNimbusConf_result.new()
      result.success = @handler.getNimbusConf()
      write_result(result, oprot, 'getNimbusConf', seqid)
    end

    def process_getClusterInfo(seqid, iprot, oprot)
      args = read_args(iprot, GetClusterInfo_args)
      result = GetClusterInfo_result.new()
      result.success = @handler.getClusterInfo()
      write_result(result, oprot, 'getClusterInfo', seqid)
    end

    def process_getTopologyInfo(seqid, iprot, oprot)
      args = read_args(iprot, GetTopologyInfo_args)
      result = GetTopologyInfo_result.new()
      begin
        result.success = @handler.getTopologyInfo(args.id)
      rescue ::NotAliveException => e
        result.e = e
      end
      write_result(result, oprot, 'getTopologyInfo', seqid)
    end

    def process_getTopologyConf(seqid, iprot, oprot)
      args = read_args(iprot, GetTopologyConf_args)
      result = GetTopologyConf_result.new()
      begin
        result.success = @handler.getTopologyConf(args.id)
      rescue ::NotAliveException => e
        result.e = e
      end
      write_result(result, oprot, 'getTopologyConf', seqid)
    end

    def process_getTopology(seqid, iprot, oprot)
      args = read_args(iprot, GetTopology_args)
      result = GetTopology_result.new()
      begin
        result.success = @handler.getTopology(args.id)
      rescue ::NotAliveException => e
        result.e = e
      end
      write_result(result, oprot, 'getTopology', seqid)
    end

    def process_getUserTopology(seqid, iprot, oprot)
      args = read_args(iprot, GetUserTopology_args)
      result = GetUserTopology_result.new()
      begin
        result.success = @handler.getUserTopology(args.id)
      rescue ::NotAliveException => e
        result.e = e
      end
      write_result(result, oprot, 'getUserTopology', seqid)
    end

  end

  # HELPER FUNCTIONS AND STRUCTURES

  class SubmitTopology_args
    include ::Thrift::Struct, ::Thrift::Struct_Union
    NAME = 1
    UPLOADEDJARLOCATION = 2
    JSONCONF = 3
    TOPOLOGY = 4

    FIELDS = {
      NAME => {:type => ::Thrift::Types::STRING, :name => 'name'},
      UPLOADEDJARLOCATION => {:type => ::Thrift::Types::STRING, :name => 'uploadedJarLocation'},
      JSONCONF => {:type => ::Thrift::Types::STRING, :name => 'jsonConf'},
      TOPOLOGY => {:type => ::Thrift::Types::STRUCT, :name => 'topology', :class => ::StormTopology}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class SubmitTopology_result
    include ::Thrift::Struct, ::Thrift::Struct_Union
    E = 1
    ITE = 2

    FIELDS = {
      E => {:type => ::Thrift::Types::STRUCT, :name => 'e', :class => ::AlreadyAliveException},
      ITE => {:type => ::Thrift::Types::STRUCT, :name => 'ite', :class => ::InvalidTopologyException}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class SubmitTopologyWithOpts_args
    include ::Thrift::Struct, ::Thrift::Struct_Union
    NAME = 1
    UPLOADEDJARLOCATION = 2
    JSONCONF = 3
    TOPOLOGY = 4
    OPTIONS = 5

    FIELDS = {
      NAME => {:type => ::Thrift::Types::STRING, :name => 'name'},
      UPLOADEDJARLOCATION => {:type => ::Thrift::Types::STRING, :name => 'uploadedJarLocation'},
      JSONCONF => {:type => ::Thrift::Types::STRING, :name => 'jsonConf'},
      TOPOLOGY => {:type => ::Thrift::Types::STRUCT, :name => 'topology', :class => ::StormTopology},
      OPTIONS => {:type => ::Thrift::Types::STRUCT, :name => 'options', :class => ::SubmitOptions}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class SubmitTopologyWithOpts_result
    include ::Thrift::Struct, ::Thrift::Struct_Union
    E = 1
    ITE = 2

    FIELDS = {
      E => {:type => ::Thrift::Types::STRUCT, :name => 'e', :class => ::AlreadyAliveException},
      ITE => {:type => ::Thrift::Types::STRUCT, :name => 'ite', :class => ::InvalidTopologyException}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class KillTopology_args
    include ::Thrift::Struct, ::Thrift::Struct_Union
    NAME = 1

    FIELDS = {
      NAME => {:type => ::Thrift::Types::STRING, :name => 'name'}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class KillTopology_result
    include ::Thrift::Struct, ::Thrift::Struct_Union
    E = 1

    FIELDS = {
      E => {:type => ::Thrift::Types::STRUCT, :name => 'e', :class => ::NotAliveException}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class KillTopologyWithOpts_args
    include ::Thrift::Struct, ::Thrift::Struct_Union
    NAME = 1
    OPTIONS = 2

    FIELDS = {
      NAME => {:type => ::Thrift::Types::STRING, :name => 'name'},
      OPTIONS => {:type => ::Thrift::Types::STRUCT, :name => 'options', :class => ::KillOptions}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class KillTopologyWithOpts_result
    include ::Thrift::Struct, ::Thrift::Struct_Union
    E = 1

    FIELDS = {
      E => {:type => ::Thrift::Types::STRUCT, :name => 'e', :class => ::NotAliveException}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class Activate_args
    include ::Thrift::Struct, ::Thrift::Struct_Union
    NAME = 1

    FIELDS = {
      NAME => {:type => ::Thrift::Types::STRING, :name => 'name'}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class Activate_result
    include ::Thrift::Struct, ::Thrift::Struct_Union
    E = 1

    FIELDS = {
      E => {:type => ::Thrift::Types::STRUCT, :name => 'e', :class => ::NotAliveException}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class Deactivate_args
    include ::Thrift::Struct, ::Thrift::Struct_Union
    NAME = 1

    FIELDS = {
      NAME => {:type => ::Thrift::Types::STRING, :name => 'name'}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class Deactivate_result
    include ::Thrift::Struct, ::Thrift::Struct_Union
    E = 1

    FIELDS = {
      E => {:type => ::Thrift::Types::STRUCT, :name => 'e', :class => ::NotAliveException}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class Rebalance_args
    include ::Thrift::Struct, ::Thrift::Struct_Union
    NAME = 1
    OPTIONS = 2

    FIELDS = {
      NAME => {:type => ::Thrift::Types::STRING, :name => 'name'},
      OPTIONS => {:type => ::Thrift::Types::STRUCT, :name => 'options', :class => ::RebalanceOptions}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class Rebalance_result
    include ::Thrift::Struct, ::Thrift::Struct_Union
    E = 1
    ITE = 2

    FIELDS = {
      E => {:type => ::Thrift::Types::STRUCT, :name => 'e', :class => ::NotAliveException},
      ITE => {:type => ::Thrift::Types::STRUCT, :name => 'ite', :class => ::InvalidTopologyException}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class BeginFileUpload_args
    include ::Thrift::Struct, ::Thrift::Struct_Union

    FIELDS = {

    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class BeginFileUpload_result
    include ::Thrift::Struct, ::Thrift::Struct_Union
    SUCCESS = 0

    FIELDS = {
      SUCCESS => {:type => ::Thrift::Types::STRING, :name => 'success'}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class UploadChunk_args
    include ::Thrift::Struct, ::Thrift::Struct_Union
    LOCATION = 1
    CHUNK = 2

    FIELDS = {
      LOCATION => {:type => ::Thrift::Types::STRING, :name => 'location'},
      CHUNK => {:type => ::Thrift::Types::STRING, :name => 'chunk', :binary => true}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class UploadChunk_result
    include ::Thrift::Struct, ::Thrift::Struct_Union

    FIELDS = {

    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class FinishFileUpload_args
    include ::Thrift::Struct, ::Thrift::Struct_Union
    LOCATION = 1

    FIELDS = {
      LOCATION => {:type => ::Thrift::Types::STRING, :name => 'location'}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class FinishFileUpload_result
    include ::Thrift::Struct, ::Thrift::Struct_Union

    FIELDS = {

    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class BeginFileDownload_args
    include ::Thrift::Struct, ::Thrift::Struct_Union
    FILE = 1

    FIELDS = {
      FILE => {:type => ::Thrift::Types::STRING, :name => 'file'}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class BeginFileDownload_result
    include ::Thrift::Struct, ::Thrift::Struct_Union
    SUCCESS = 0

    FIELDS = {
      SUCCESS => {:type => ::Thrift::Types::STRING, :name => 'success'}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class DownloadChunk_args
    include ::Thrift::Struct, ::Thrift::Struct_Union
    ID = 1

    FIELDS = {
      ID => {:type => ::Thrift::Types::STRING, :name => 'id'}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class DownloadChunk_result
    include ::Thrift::Struct, ::Thrift::Struct_Union
    SUCCESS = 0

    FIELDS = {
      SUCCESS => {:type => ::Thrift::Types::STRING, :name => 'success', :binary => true}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class GetNimbusConf_args
    include ::Thrift::Struct, ::Thrift::Struct_Union

    FIELDS = {

    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class GetNimbusConf_result
    include ::Thrift::Struct, ::Thrift::Struct_Union
    SUCCESS = 0

    FIELDS = {
      SUCCESS => {:type => ::Thrift::Types::STRING, :name => 'success'}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class GetClusterInfo_args
    include ::Thrift::Struct, ::Thrift::Struct_Union

    FIELDS = {

    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class GetClusterInfo_result
    include ::Thrift::Struct, ::Thrift::Struct_Union
    SUCCESS = 0

    FIELDS = {
      SUCCESS => {:type => ::Thrift::Types::STRUCT, :name => 'success', :class => ::ClusterSummary}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class GetTopologyInfo_args
    include ::Thrift::Struct, ::Thrift::Struct_Union
    ID = 1

    FIELDS = {
      ID => {:type => ::Thrift::Types::STRING, :name => 'id'}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class GetTopologyInfo_result
    include ::Thrift::Struct, ::Thrift::Struct_Union
    SUCCESS = 0
    E = 1

    FIELDS = {
      SUCCESS => {:type => ::Thrift::Types::STRUCT, :name => 'success', :class => ::TopologyInfo},
      E => {:type => ::Thrift::Types::STRUCT, :name => 'e', :class => ::NotAliveException}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class GetTopologyConf_args
    include ::Thrift::Struct, ::Thrift::Struct_Union
    ID = 1

    FIELDS = {
      ID => {:type => ::Thrift::Types::STRING, :name => 'id'}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class GetTopologyConf_result
    include ::Thrift::Struct, ::Thrift::Struct_Union
    SUCCESS = 0
    E = 1

    FIELDS = {
      SUCCESS => {:type => ::Thrift::Types::STRING, :name => 'success'},
      E => {:type => ::Thrift::Types::STRUCT, :name => 'e', :class => ::NotAliveException}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class GetTopology_args
    include ::Thrift::Struct, ::Thrift::Struct_Union
    ID = 1

    FIELDS = {
      ID => {:type => ::Thrift::Types::STRING, :name => 'id'}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class GetTopology_result
    include ::Thrift::Struct, ::Thrift::Struct_Union
    SUCCESS = 0
    E = 1

    FIELDS = {
      SUCCESS => {:type => ::Thrift::Types::STRUCT, :name => 'success', :class => ::StormTopology},
      E => {:type => ::Thrift::Types::STRUCT, :name => 'e', :class => ::NotAliveException}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class GetUserTopology_args
    include ::Thrift::Struct, ::Thrift::Struct_Union
    ID = 1

    FIELDS = {
      ID => {:type => ::Thrift::Types::STRING, :name => 'id'}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class GetUserTopology_result
    include ::Thrift::Struct, ::Thrift::Struct_Union
    SUCCESS = 0
    E = 1

    FIELDS = {
      SUCCESS => {:type => ::Thrift::Types::STRUCT, :name => 'success', :class => ::StormTopology},
      E => {:type => ::Thrift::Types::STRUCT, :name => 'e', :class => ::NotAliveException}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

end

