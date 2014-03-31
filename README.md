# uGit – The ultimate undo button for Git

Command-line wrapper for undoing *any* Git action so you can rebase fearlessly.

uGit saves incrimental versions of your entire repo (including your `.git` directory) before each Git action. It's the functional equivavlent of copying of your entire repo before typing a Git command, except 100x awesomer.

## Installation

todo

## Aliasing

todo

### Shell tab-completion

todo

## Commands

Assuming you've aliased `git` to `ugit`, you can type Git commands as usual

    $ git add file1 file2
    $ git pull --rebase
    
#### undo

`git undo` restores your repo to the state it was in immediately prior to your most recent Git command. Before restoring the previous state, uGit saves the state before the `undo` (so you can `git undo` a `git undo`, and on and on).

    $ git undo
    84f66c2cdffeee1aebb2a3244cc1e726615b777d RESTORED BEFORE pull --rebase (Thu Mar 6 12:47:31 2014 -0800)
    95a21b1959c7a03f84de4c2cbb8b77c947998f65 BEFORE undo (Thu Mar 6 11:35:20 2014 -0800)
    
#### command-log

`git command-log` lists  your git command history

    $ git command-log
    84f66c2cdffeee1aebb2a3244cc1e726615b777d BEFORE pull --rebase (Thu Mar 6 12:47:31 2014 -0800)
    95a21b1959c7a03f84de4c2cbb8b77c947998f65 BEFORE add file1 file2 (Thu Mar 6 11:35:20 2014 -0800)
        
#### restore

`git restore <shaw>` restores your repo to the state it was in before you typed the command at `<shaw>`

    $ git restore 84f66c2cdffeee1aebb2a3244cc1e726615b777d
    Froze current state as "BEFORE restore 84f66c2cdffeee1aebb2a3244cc1e726615b777d"
    State restored to "BEFORE pull --rebase" on Thu Mar 6 12:47:31 2014 -0800 (84f66c2cdffeee1aebb2a3244cc1e726615b777d)
    
