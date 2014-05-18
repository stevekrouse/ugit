module Ugit
  class Runner

    def initialize(args)
      @args = args
      @ugit = Ugit::Ugit.new
    end

    def execute
      if @args[0] == 'restore' && @args[1] =~ /[a-f0-9]{40}/
        @ugit.restore(@args[1])
      elsif (@args = /^undo$/.match(command_string))
        @ugit.restore(@ugit.freezer.git.last_commit_sha)
      else
        @ugit.execute(command_string)
      end
    end

  end
end
