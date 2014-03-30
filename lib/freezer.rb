require "#{File.dirname(__FILE__)}/git"
require 'pry'

class Freezer

  attr_accessor :git

  def initialize(work_tree, git_dirname)
    @git = Git.new(work_tree, git_dirname)
    @git.exists?
    init if not @git.exists?
  end

  def freeze(msg)
    if @git.head_sha == try_freeze(msg)
      # TODO think about forcing seperate commits (but I think this is better - conveys more info)
      @git.amend_last_commit_msg(%Q[#{msg}\n#{@git.msg_by_sha(old_sha)}])
    end
  end

  def try_freeze(msg)
    @git.execute(%Q[add -A])
    @git.execute(%Q[commit -m "#{msg}"])
    @git.head_sha
  end

  # commits the current state of the working tree
  # reverts every commit to shaw (not including)
  # commits the restored state as a new state on top of everything (to not lose history)
  def restore(shaw, current_state_msg, restored_state_msg)
    @git.execute(%Q[add -A])
    @git.execute(%Q[commit -m "#{current_state_msg}"])
    @git.execute(%Q[revert -n #{shaw}..HEAD])
    @git.execute(%Q[commit -m "#{restored_state_msg}"])
  end

  def init
    @git.execute('init')
    @git.ignore(@git.git_dirname)
    without_empty_dir do
      try_freeze("INITIALIZED")
    end
  end

  def log
    @git.execute('log')
  end

  def without_empty_dir
    empty_dir? ? force_empty_commit {yield} : yield
  end

  def force_empty_commit
    `touch #{@git.work_tree}/empty-dir`
    yield  # git commit
  ensure
    `rm #{@git.work_tree}/empty-dir`
    @git.execute("commit --amend --no-edit")
  end

  def empty_dir?
    # TODO empty-dir -> .empty-dir
    `ls -a #{git.work_tree}`.split("\n").select{|e| !e.start_with?('.')} == []
  end

  # TODO make empty dirs tracked by adding/removing .empty_dir to them
  # with_tracked_empty_dirs do
  #   `#{ffreeze_git} add -A`
  #   `#{ffreeze_git} commit -m "#{msg}"`
  # end

  # def with_tracked_empty_dirs
  #   dirs = empty_dirs
  #   dirs.each {|dn| `touch #{dn}/.empty-dir` }
  #   yield
  #   dirs.each {|dn| `rm #{dn}/.empty-dir` }
  # end

  # def empty_dirs
  #   Dir["#{@work_tree}/**/*"].each do |fn|
  #     File.directory?(fn) && Dir.entries('/Users/steve/Dropbox/dev/ugit/folderfreeze.md') == 2
  #   end
  # end

end
