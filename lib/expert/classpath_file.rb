# encoding: UTF-8

module Expert
  class ClasspathFile
    attr_reader :paths

    class << self
      def from_path(path)
        new(load(path))
      end

      protected

      def load(path)
        File.read(path).split(':')
      end
    end

    def initialize(paths)
      @paths = paths
    end

    def require_all
      paths.each { |p| Kernel.require(p) }
    end
  end
end
