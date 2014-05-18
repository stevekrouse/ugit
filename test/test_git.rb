require 'test/unit'
require 'ugit/git'

class TestUgit < Test::Unit::TestCase

  def setup
    @work_tree = "test/test-working-dir"
    @git_dirname = ".git"

    `mkdir #{@work_tree}`

    @git = Ugit::Git.new(@work_tree, @git_dirname)
    @git.execute("init")
  end

  def teardown
    `rm -rf #{@work_tree}`
  end

  def excludes
    File.read("#{@git.dir}/info/exclude").split("\n")
  end

  def test_exists
    assert @git.exists?, "not correctly detecting .git dir"

    `rm -rf test/test-working-dir/.git`

    assert !@git.exists?, "incorrectly found .git dir when not present"
  end

  def test_work_tree
    assert_equal @work_tree, @git.work_tree
  end

  def test_ignore
    @git.ignore "test1"
    assert excludes.include?("test1"), "ignore did not add fn to excludes"

    @git.ignore "test2"
    assert excludes.include?("test2"), "ignore did not add fn to excludes"

    @git.ignore "test1"
    assert_equal 1, excludes.count{|fn| fn == "test1"}
  end

  def test_amend_last_commit_msg
   `touch #{@work_tree}/a`
    @git.add_all()

    @git.execute('commit -m "first"')
    @git.amend_last_commit_msg("second")

    assert_equal "second", @git.msg_by_sha(@git.head_sha)
  end
end
