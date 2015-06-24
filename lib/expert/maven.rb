# encoding: UTF-8

module Expert
  class Maven

    class << self
      def execute(cmd)
        system("#{mvn_path} #{cmd}")
      end

      def resolve
        execute('dependency:resolve')
      end

      def build_classpath(output_file)
        execute("dependency:build-classpath -Dmdep.outputFile=#{output_file}")
      end

      def mvn_path
        @mvn_path ||= File.expand_path(
          "../../../vendor/apache-maven-#{Expert::MAVEN_VERSION}/bin/mvn",
          __FILE__
        )
      end
    end

  end
end
