module Ugit
  class Runner

    def initialize(args)
      @args = args
    end

    def execute
      if @args[0] == 'init'
        `git #{command_string}`
      elsif @args[0] == 'restore' && @args[1] =~ /^v[0-9]+S/
        ugit.restore(@args[1])
      elsif @args[0] == 'undo'
        ugit.undo
      elsif @args[0] == 'history'
        ugit.history.print
      else
        ugit.execute(command_string)
      end
    end

    def ugit
      @ugit ||= Ugit.new
    end

    def command_string
      command_string ||= @args.join(" ")
    end
  end
end
