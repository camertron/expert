# encoding: UTF-8

module Expert
  class DependenciesNotInstalledError < StandardError; end

  class Environment
    attr_reader :jarfile, :pom, :classpath

    def initialize(jarfile, pom, classpath)
      @jarfile = jarfile
      @pom = pom
      @classpath = classpath
    end

    def install
      install_pom
      install_classpath
    end

    def installed?
      pom && classpath
    end

    def require_all
      if installed?
        classpath.require_all
      else
        raise DependenciesNotInstalledError,
          "Maven dependencies haven't been installed yet (did you forget to "\
          "run `expert install`?)"
      end
    end

    protected

    def install_pom
      @pom = PomFile.new(jarfile.dependencies)
      pom.write(Expert.pom_path)
    end

    def install_classpath
      mvn.resolve
      mvn.build_classpath(Expert.classpath_file_path)
      @classpath = ClasspathFile.from_path(Expert.classpath_file_path)
    end

    def mvn
      Expert::Maven
    end
  end
end
