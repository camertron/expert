# encoding: UTF-8

module Expert
  class UnexpectedTokenError < StandardError; end

  class JarfileParser
    attr_reader :tokens, :index

    def initialize(tokens)
      @tokens = tokens
    end

    def each_dependency(&block)
      rewind
      each_jar(&block)
    end

    def dependencies
      rewind
      each_jar.to_a
    end

    protected

    def each_jar
      if block_given?
        consume
        yield jar until eos?
      else
        to_enum(__method__)
      end
    end

    def jar
      consume(:jar)
      consume(:quote)
      group_id, artifact_id = consume(:string).value.split(':')
      consume(:quote)
      consume(:comma)
      consume(:quote)
      version = consume(:string).value
      consume(:quote)
      JarDependency.new(group_id, artifact_id, version)
    end

    def consume(type = nil)
      token = current_token

      if type
        if current_token.type == type && !eos?
          @index += 1
        else
          raise UnexpectedTokenError,
            "Expected token of type '#{type}', got '#{current_token.type}'"
        end
      end

      while should_skip_current?
        @index += 1
      end

      token
    end

    def should_skip_current?
      !eos? && current_token.type == :comment
    end

    def current_token
      tokens[index]
    end

    def eos?
      index >= tokens.size
    end

    def rewind
      @index = 0
    end
  end
end
