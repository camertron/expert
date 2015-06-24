# encoding: UTF-8

require 'rexml/document'

module Expert
  class PomFile
    attr_reader :dependencies

    class << self
      def from_path(path)
        new(load(path))
      end

      protected

      def load(path)
        doc = REXML::Document.new(File.read(path))

        [].tap do |dependencies|
          doc.elements.each('project/dependencies/dependency') do |element|
            group_id = find_element_text('groupId', element)
            artifact_id = find_element_text('artifactId', element)
            version = find_element_text('version', element)
            dependencies << JarDependency.new(
              group_id, artifact_id, version
            )
          end
        end
      end

      def find_element_text(name, root)
        if found_elem = find_element(name, root)
          found_elem.text
        end
      end

      def find_element(name, root)
        root.elements.find { |elem| elem.name == name }
      end
    end

    def initialize(dependencies)
      @dependencies = dependencies
    end

    def write(path)
      doc = construct

      File.open(path, 'w+') do |f|
        formatter.write(doc, f)
      end
    end

    protected

    def construct
      REXML::Document.new.tap do |doc|
        with_header(doc) do |element|
          dependencies_elem = element.add_element('dependencies')
          dependencies.each do |dependency|
            write_dependency(dependency, dependencies_elem)
          end
        end
      end
    end

    def write_dependency(dependency, element)
      dependency_elem = element.add_element('dependency')
      dependency_elem.add_element('groupId').add_text(dependency.group_id)
      dependency_elem.add_element('artifactId').add_text(dependency.artifact_id)
      dependency_elem.add_element('version').add_text(dependency.version)
    end

    def with_header(doc)
      doc << REXML::XMLDecl.new('1.0', 'UTF-8')

      project_elem = doc.add_element('project', {
        'xmlns' => 'http://maven.apache.org/POM/4.0.0',
        'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
        'xsi:schemaLocation' => 'http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd'
      })

      dir = File.basename(File.expand_path('./'))
      project_elem.add_element('groupId').add_text(dir)
      project_elem.add_element('artifactId').add_text(dir)
      project_elem.add_element('version').add_text('1.0-SNAPSHOT')
      project_elem.add_element('modelVersion').add_text('4.0.0')
      yield project_elem
    end

    def formatter
      @formatter ||= REXML::Formatters::Pretty.new(2).tap do |formatter|
        formatter.compact = true
      end
    end
  end
end
