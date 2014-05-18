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

Assuming you've aliased `git` to `ugit`, you can type Git commands as usual

    $ git add file1 file2
    $ git pull --rebase

#### commands

`git commands` lists your each git command you typed and the state immediately before you typed it below

    $ git history
            pull --rebase (Thu Mar 6 12:47:31 2014 -0800)
    84f66c2
            add file1 file2 (Thu Mar 6 11:35:20 2014 -0800)
    95a21b1

#### restore

`git restore <shaw>` restores your repo to the state it was in before you typed the command above `<shaw>`

    $ git restore 84f66c2
    $ git commands
    Thu 3/6 12:48 restore 84f66c2
    84f66c2
    Thu 3/6 12:47 pull --rebase
    95a21b1
    Thu 3/6 11:35 add file1 file2
    234lkds

    $ git commands
    Thu 3/6 12:48 restore 84f66c2
    84f66c2
    Thu 3/6 12:47 pull --rebase
    95a21b1

     [v0] Initial State
     [v1] - add file1 file2 - Thu 3/6 11:35
     [..]
     v21 | before | add file1 file2 | Thu 3/6 11:35
     v22 | after  | add file1 file2 | Thu 3/6 11:35
     ----------------------------------------------
     v23 | before | pull            | Thu 3/6 10:35
     v24 | after  | pull            | Thu 3/6 10:35
     ----------------------------------------------
     v25 | before | add file1 file2 | Thu 3/6 11:35
    *v26 | after  | add file1 file2 | Thu 3/6 11:35

    git undo


## Contributing

1. Fork it ( http://github.com/stevekrouse/ugit/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
