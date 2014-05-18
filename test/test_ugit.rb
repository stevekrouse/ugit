require 'test/unit'
require 'ugit'

class TestUgit < Test::Unit::TestCase

  def setup
    @work_tree = "test/test-working-dir"

    `mkdir #{@work_tree}`

    @git = Ugit::Git.new(@work_tree, ".git")
    @git.execute("init")

    @ugit = Ugit::Ugit.new(@work_tree)
  end

  def teardown
    `rm -rf #{@work_tree}`
  end

  def added_files
    @git.execute("diff --name-only --cached").split("\n")
  end

  def test_git_dir_in_correct_location
    assert File.exist?("#{@work_tree}/.ugit")
  end

  def test_files_add_restore
    `touch #{@work_tree}/a #{@work_tree}/b #{@work_tree}/c`
    @ugit.execute('add a b')
    old_sha = @ugit.freezer.git.head_sha

    @ugit.restore(old_sha)

    # test restore
    assert_equal [], added_files()

    # test freeze before restore
    old_old_sha = @ugit.freezer.git.execute("rev-parse HEAD~1").chomp
    @ugit.restore(old_old_sha)
    assert_equal ["a", "b"], added_files()
  end

  def test_directory_add_restore
    `mkdir #{@work_tree}/a #{@work_tree}/b`
    `touch #{@work_tree}/a/a #{@work_tree}/a/b #{@work_tree}/b/a #{@work_tree}/b/b`
    @ugit.execute('add a/a a/b b/a')
    old_sha = @ugit.freezer.git.head_sha

    @ugit.restore(old_sha)

    # test restore
    assert_equal [], added_files()

    # test freeze before restore
    old_old_sha = @ugit.freezer.git.execute("rev-parse HEAD~1").chomp
    @ugit.restore(old_old_sha)
    assert_equal ["a/a", "a/b", "b/a"], added_files()
  end

  def test_restore_of_restore

  end
end
