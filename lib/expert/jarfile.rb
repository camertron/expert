# encoding: UTF-8

module Expert
  class Jarfile
    attr_reader :dependencies

    class << self
      def from_path(jarfile_path)
        new(load(jarfile_path))
      end

      protected

      def load(jarfile_path)
        jar_deps = parse(jar_requirements_from_gems.join("\n"))
        jarfile_deps = parse(File.read(jarfile_path))
        (jar_deps + jarfile_deps).uniq(&:classifier)
      end

      def parse(contents)
        tokens = JarfileTokenizer.tokenize(contents)
        JarfileParser.new(tokens).dependencies
      end

      def jar_requirements_from_gems
        requirements_from_gems.select do |requirement|
          requirement.respond_to?(:start_with?) && requirement.start_with?('jar ')
        end
      end

      def requirements_from_gems
        Bundler.environment.specs.flat_map(&:requirements)
      end
    end

    def initialize(dependencies)
      @dependencies = dependencies
    end
  end
end
