require 'test/unit'
require 'ugit/git'
require 'ugit/freezer'
require 'pry'
require 'pry-nav'
require 'pry-stack_explorer'

class TestFreezer < Test::Unit::TestCase

  def setup
    @work_tree = "test/test-working-dir"
    @freezer_dirname = ".freezer"

    `mkdir #{@work_tree}`

    @freezer = Ugit::Freezer.new(@work_tree, @freezer_dirname)
  end

  def teardown
    `rm -rf #{@work_tree}`
  end

  def test_freezer_dir_in_correct_location
    assert File.exist?("#{@work_tree}/#{@freezer_dirname}")
  end

  def test_try_freeze_empty
    # try_freeze("INITIALIZED", allow_empty=true)  # called in initialized -> init
    assert_equal "INITIALIZED", @freezer.git.msg_by_sha(@freezer.git.head_sha)
  end

  def test_try_freeze
    `mkdir #{@work_tree}/a`
    `touch #{@work_tree}/a/b #{@work_tree}/c`
    @freezer.try_freeze("TEST")

    assert_equal "TEST", @freezer.git.msg_by_sha(@freezer.git.head_sha)
  end

  def test_freeze_amend
    @freezer.freeze("status")

    assert_equal "status\nINITIALIZED", @freezer.git.msg_by_sha(@freezer.git.head_sha)
  end

  def test_files_restore
    `touch #{@work_tree}/a #{@work_tree}/b #{@work_tree}/c`
    @freezer.freeze("froze a b c")
    old_sha = @freezer.git.head_sha

    `rm #{@work_tree}/a #{@work_tree}/b`
    `touch #{@work_tree}/d`

    @freezer.restore(old_sha, "removed a b; add d", "restored a b c")
    assert_equal ["a", "b", "c"], `ls #{@work_tree}`.split("\n")
  end

  def test_directory_restore
    `mkdir #{@work_tree}/a #{@work_tree}/b`
    `touch #{@work_tree}/a/a #{@work_tree}/a/b #{@work_tree}/b/a #{@work_tree}/b/b`
    @freezer.freeze("froze a/a a/b b/a b/b")
    old_sha = @freezer.git.head_sha

    `rm -rf #{@work_tree}/a`
    `touch #{@work_tree}/b/c`

     @freezer.restore(old_sha, "removed a/*; added b/c", "restored dir a/* b/a b/c")
     files = `find #{@work_tree} -type f`.split("\n").select{|fn| fn !~ /.freezer/}
     assert_equal ["#{@work_tree}/a/a", "#{@work_tree}/a/b", "#{@work_tree}/b/a", "#{@work_tree}/b/b"], files
  end

  # def test_empty_directory_restore
  #   `mkdir #{@work_tree}/a #{@work_tree}/b #{@work_tree}/c`
  #   @freezer.freeze("froze a b c")
  #   old_sha = @freezer.git.head_sha

  #   `rm -rf #{@work_tree}/a #{@work_tree}/b #{@work_tree}/c`

  #   assert_equal `ls #{@work_tree}`.split("\n"), []
  #   @freezer.restore(old_sha, "removed a b c", "restored a b c")
  #   assert_equal `ls #{@work_tree}`.split("\n"), ["a", "b", "c"]
  # end

end
