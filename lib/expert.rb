# encoding: UTF-8

module Expert
  autoload :ClasspathFile,    'expert/classpath_file'
  autoload :Cli,              'expert/cli'
  autoload :Environment,      'expert/environment'
  autoload :Jarfile,          'expert/jarfile'
  autoload :JarDependency,    'expert/jar_dependency'
  autoload :JarfileParser,    'expert/jarfile_parser'
  autoload :JarfileTokenizer, 'expert/jarfile_tokenizer'
  autoload :Maven,            'expert/maven'
  autoload :PomFile,          'expert/pom_file'

  # The Jarfile declares dependencies. The pom/classpath function like a
  # Gemfile.lock or Jarfile.lock.
  DEFAULT_JARFILE_PATH = './Jarfile'
  DEFAULT_POM_PATH = './pom.xml'
  DEFAULT_CLASSPATH_FILE = './classpath.txt'
  MAVEN_VERSION = '3.3.3'

  class << self
    def environment
      @environment ||= begin
        check_bundler_required
        check_jarfile_exists

        Environment.new(load_jarfile, load_pom, load_classpath)
      end
    end

    def jarfile_path
      ENV.fetch('EXPERT_JARFILE', DEFAULT_JARFILE_PATH)
    end

    def pom_path
      ENV.fetch('EXPERT_POM', DEFAULT_POM_PATH)
    end

    def classpath_file_path
      ENV.fetch('EXPERT_CLASSPATH_FILE', DEFAULT_CLASSPATH_FILE)
    end

    protected

    def check_bundler_required
      unless defined?(Bundler)
        raise "Bundler hasn't been required. Please run expert in the context "\
          "of your bundle."
      end
    end

    def check_jarfile_exists
      unless File.exist?(jarfile_path)
        raise "Couldn't find a Jarfile at #{jarfile_path}. A Jarfile is "\
          "required to declare jar dependencies. You can manually specify a "\
          "Jarfile location via the EXPERT_JARFILE environment variable."
      end
    end

    def load_jarfile
      Jarfile.from_path(jarfile_path)
    end

    def load_pom
      if File.exist?(pom_path)
        PomFile.from_path(pom_path)
      end
    end

    def load_classpath
      if File.exist?(classpath_file_path)
        ClasspathFile.from_path(classpath_file_path)
      end
    end
  end
end
