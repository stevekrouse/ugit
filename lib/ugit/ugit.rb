module Ugit
  class Ugit

    attr_accessor :git, :freezer

    def initialize(work_tree=nil)
      work_tree ||= Git.work_tree
      @git = Git.new(work_tree, '.git')

      raise "Not in a git directory" if not @git.exists?

      @freezer = Freezer.new(work_tree, ".ugit")

      @git.ignore('.ugit')
      @freezer.git.ignore('.git')
    end

    def execute(git_command)
      freeze("BEFORE #{git_command}")
      output = @git.execute(git_command)
      puts output unless output == "\n" || output.empty?
      freeze("AFTER #{git_command}")
    end

    def freeze(git_command)
      with_moved_git_dir do
        @freezer.freeze(%Q[BEFORE #{git_command}])
      end
    end

    def undo
      restore(self.freezer.git.last_commit_sha)
    end

     def restore(sha)
      with_moved_git_dir do
        @freezer.restore(sha,
          "BEFORE restore #{sha}",
          "RESTORED #{@freezer.git.msg_by_sha(sha)} (#{sha})")
      end
    end

    def history
      History.new(@freezer.git)
    end

    def log
      @freezer.log
    end

    def with_moved_git_dir
      `mv #{@git.dir}/ #{@git.work_tree}/.git-moved`
      yield
    ensure
      `mv #{@git.work_tree}/.git-moved/ #{@git.dir}`
    end

  end
end
