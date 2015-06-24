# encoding: UTF-8

module Expert
  class JarDependency
    attr_reader :group_id, :artifact_id, :version

    def initialize(group_id, artifact_id, version)
      @group_id = group_id
      @artifact_id = artifact_id
      @version = version
    end

    def classifier
      "#{group_id}:#{artifact_id}"
    end
  end
end
