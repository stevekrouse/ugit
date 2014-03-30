require 'test/unit'
require "#{File.dirname(__FILE__)}/../lib/freezer"
require 'pry'

class TestFreezer < Test::Unit::TestCase

  def setup
    `mkdir test-working-dir`
    @freezer = Freezer.new("#{`pwd`.chomp}/test-working-dir", ".freezer")
  end

  def teardown
    `rm -rf test-working-dir`
  end

  def test_git_dir_in_correct_location
    assert File.exist?('test-working-dir/.freezer')
  end

  def test_files_restore
    `touch test-working-dir/a test-working-dir/b test-working-dir/c`
    @freezer.freeze("froze a b c")
    old_sha = @freezer.git.head_sha

    `rm test-working-dir/a test-working-dir/b test-working-dir/c`

    @freezer.restore(old_sha, "removed a b c", "restored a b c")
    assert_equal ["a", "b", "c"], `ls test-working-dir`.split("\n")
  end

  def test_directory_restore
    `mkdir test-working-dir/a test-working-dir/b`
    `touch test-working-dir/a/a test-working-dir/a/b test-working-dir/b/a test-working-dir/b/b`
    @freezer.freeze("froze a/a a/b b/a b/b")
    old_sha = @freezer.git.head_sha

    `rm -rf test-working-dir/a`

     @freezer.restore(old_sha, "removed dir a", "restored dir a b")
     files = `find test-working-dir -type f`.split("\n").select {|fn| fn !~ /.freezer/}
     assert_equal ["test-working-dir/a/a", "test-working-dir/a/b", "test-working-dir/b/a", "test-working-dir/b/b"], files
  end



  # def test_empty_directory_restore
  #   `mkdir test-working-dir/a test-working-dir/b test-working-dir/c`
  #   @freezer.freeze("froze a b c")
  #   old_sha = @freezer.git.head_sha

  #   `rm -rf test-working-dir/a test-working-dir/b test-working-dir/c`

  #   assert_equal `ls test-working-dir`.split("\n"), []
  #   @freezer.restore(old_sha, "removed a b c", "restored a b c")
  #   assert_equal `ls test-working-dir`.split("\n"), ["a", "b", "c"]
  # end

end
