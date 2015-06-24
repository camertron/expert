# encoding: UTF-8

module Expert
  class Cli
    class << self
      def start(argv)
        cmd = argv[0].to_sym

        if respond_to?(cmd)
          public_send(cmd, argv[1..-1])
        else
          raise "Couldn't find command '#{cmd}'"
        end
      end

      def install(args)
        Expert.environment.install
      end
    end
  end
end
