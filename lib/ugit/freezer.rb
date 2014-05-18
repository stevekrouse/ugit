module Ugit
  class Freezer
    attr_accessor :git

    def initialize(work_tree, git_dirname)
      @git = Git.new(work_tree, git_dirname)
      init if not @git.exists?
    end

    def freeze(msg)
      if @git.head_sha == try_freeze(msg)
        @git.amend_last_commit_msg(%Q[#{msg}\n#{@git.msg_by_sha(@git.head_sha)}])
      end
    end

    # attempts to commit all changed files
    # returns current sha
    def try_freeze(msg, allow_empty=false)
      @git.add_all
      @git.execute(%Q[commit -m "#{msg}"#{allow_empty ? " --allow-empty" : ""}])
      @git.head_sha
    end

    # commits the current state of the working tree
    # reverts every commit to shaw (not including)
    # commits the restored state as a new state on top of everything (to not lose history)
    def restore(shaw, current_state_msg, restored_state_msg)
      @git.add_all
      @git.execute(%Q[commit -m "#{current_state_msg}"])
      @git.execute(%Q[revert -n #{shaw}..HEAD])
      @git.execute(%Q[commit -m "#{restored_state_msg}"])
    end

    def init
      @git.execute('init')
      @git.ignore(@git.git_dirname)
      try_freeze("INITIALIZED", allow_empty=true)
    end

    def log
      @git.execute('log')
    end
  end
end
