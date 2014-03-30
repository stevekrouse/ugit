require 'test/unit'
require_relative '../lib/ugit'
require 'pry'

class TestUgit < Test::Unit::TestCase

  def setup
    `mkdir test-working-dir`
    `git --work-tree="#{`pwd`.chomp}/test-working-dir" --git-dir="#{`pwd`.chomp}/test-working-dir/.git" init`
    @ugit = Ugit.new("#{`pwd`.chomp}/test-working-dir")
  end

  def teardown
    `rm -rf test-working-dir`
  end

  # def test_git_dir_in_correct_location
  #   assert File.exist?('test-working-dir/.ugit')
  # end

  def test_files_add
    `touch test-working-dir/a test-working-dir/b test-working-dir/c`
    @ugit.execute('add a b c')
    old_sha = @ugit.freezer.git.head_sha

    @ugit.restore(old_sha)

    pry  # works, but too lazy to finish this test so you can see with pry
  end

  # def test_directory_restore
  #   `mkdir test-working-dir/a test-working-dir/b`
  #   `touch test-working-dir/a/a test-working-dir/a/b test-working-dir/b/a test-working-dir/b/b`
  #   @ffreeze.ffreeze("froze a/a a/b b/a b/b")
  #   old_sha = @ugit.freezer.git.head_sha


  #   `rm -rf test-working-dir/a`

  #    @ffreeze.restore(old_sha, "removed dir a", "restored dir a b")
  #    files = `find test-working-dir -type f`.split("\n").select {|fn| fn !~ /.ffreeze/}
  #    assert_equal files, ["test-working-dir/a/a", "test-working-dir/a/b", "test-working-dir/b/a", "test-working-dir/b/b"]
  # end

end
