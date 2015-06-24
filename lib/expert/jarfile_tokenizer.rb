# encoding: UTF-8

module Expert
  Token = Struct.new(:type, :value)

  # jar 'org.eclipse.jgit:org.eclipse.jgit', '3.4.1.201406201815-r'
  class JarfileTokenizer
    TOKEN_TYPE_REGEXES = {
      jar: /jar/,
      quote: /['"]/,
      comma: /,/,
      comment: /#.*\z/m
    }

    TOKEN_TYPES = TOKEN_TYPE_REGEXES.keys
    DEFAULT_TOKEN_TYPE = :string

    SPLITTER = Regexp.new(
      "(#{TOKEN_TYPE_REGEXES.values.map(&:source).join('|')})"
    )

    class << self
      def tokenize(content)
        raw_tokens = content.split(SPLITTER)
        identify(raw_tokens.reject { |t| t.strip.empty? })
      end

      protected

      def identify(raw_tokens)
        raw_tokens.map do |token|
          type = TOKEN_TYPES.find do |type|
            token =~ TOKEN_TYPE_REGEXES[type]
          end

          Token.new(type || DEFAULT_TOKEN_TYPE, token)
        end
      end
    end
  end
end
