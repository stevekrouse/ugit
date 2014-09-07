# uGit – The ultimate undo button for Git

Command-line wrapper for undoing *any* Git action so you can rebase fearlessly.

uGit saves incrimental versions of your entire repo (including your `.git` directory) before each Git action. It's the functional equivavlent of copying of your entire repo before typing a Git command, except 100x awesomer.

## Installation

Add this line to your application's Gemfile:

    gem 'ugit'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ugit

## Aliasing

TODO

## Shell tab-completion

TODO

## Usage

TODO use http://www.awesomecommandlineapps.com/gems.html

Assuming you've aliased `git` to `ugit`, you can type Git commands as usual

    $ git add file1 file2
    $ git pull --rebase

#### history

`git history` lists your each git command you typed

    $ git history

     v21 | before | add file1 file2 | Thu 3/6 11:35
     v22 | after  | add file1 file2 | Thu 3/6 11:35
     ----------------------------------------------
     v23 | before | pull            | Thu 3/6 10:35
     v24 | after  | pull            | Thu 3/6 10:35
     ----------------------------------------------
     v25 | before | add file1 file2 | Thu 3/6 11:35
    *v26 | after  | add file1 file2 | Thu 3/6 11:35

#### restore

`git restore v24` restores your repo to the 24th version that uGit saved. In the above case, right after you `pull`ed.

    $ git restore v24
    $ git history

     v21 | before | add file1 file2 | Thu 3/6 11:35
     v22 | after  | add file1 file2 | Thu 3/6 11:35
     ----------------------------------------------
     v23 | before | pull            | Thu 3/6 10:35
     v24 | after  | pull            | Thu 3/6 10:35
     ----------------------------------------------
     v25 | before | add file1 file2 | Thu 3/6 11:35
     v26 | after  | add file1 file2 | Thu 3/6 11:35
     ----------------------------------------------
     v27 | before | restore v24     | Thu 3/6 11:37
     v28 | before | restore v24     | Thu 3/6 11:37

As you'll notice, you don't actually go backwards in time to the 24th version. You merely slap the 24th version onto the top of your history. This allows you do `restore` fearlessly, because you can always undo your undo (and on and on).

#### undo

`git undo` restores your project to the state immediately before your last git command

    $ git undo
    Restored to immediately before your command "add file1 file2" (v25)
    $ git undo
    Restored to immediately before your command "add file1 file2" (v23)


#### redo

TODO

## Contributing

1. Fork it ( http://github.com/stevekrouse/ugit/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
