class Git

  attr_reader :work_tree, :git_dirname

  def initialize(work_tree, git_dirname)
    @work_tree = work_tree
    @git_dirname = git_dirname
  end

  def execute(command)
    `#{git} #{command}`
  end

  def git
    "git --work-tree=#{@work_tree} --git-dir=#{dir}"
  end

  def dir
    "#{@work_tree}/#{@git_dirname}"
  end

  def exists?
    execute("status 2>&1").chomp.downcase !~ /fatal: not a git repository/
  end

  def ignore(fn)
    exclude = "#{dir}/info/exclude"
    ignores = File.read(exclude).split("\n")

    if not ignores.include?(fn)
      File.open(exclude, 'a') do |file|
        file.puts fn
      end
    end
  end

  def msg_by_sha(sha)
    execute(%Q[show -s --format=%s #{sha}]).chomp
  end

  def amend_last_commit_msg(msg)
    execute(%Q[commit --amend -m "#{msg}"])
  end

  def head_sha
    execute(%Q[rev-parse HEAD]).chomp
  end

  def no_commits?
    `git log 2>&1`.chomp == %Q[fatal: bad default revision 'HEAD']
  end
end
