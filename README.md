# ugit - undoable git

some hot git-on-git action for fearless rebasing

Command line wrapper for git that allows users to "undo" the effect of any git action.

    $ ugit add file1 file2

    $ ugit pull --rebase

    $ ugit freeze-list
    commit 84f66c2cdffeee1aebb2a3244cc1e726615b777d
    Author: Steve Krouse <steve@looker.com>
    Date:   Thu Mar 6 12:47:31 2014 -0800

        STATE BEFORE: 'ugit pull --rebase'

    commit 95a21b1959c7a03f84de4c2cbb8b77c947998f65
    Author: Steve Krouse <steve@looker.com>>
    Date:   Thu Mar 6 11:35:20 2014 -0800

        STATE BEFORE: 'ugit add file1 file2'

    $ ugit restore 84f66c2cdffeee1aebb2a3244cc1e726615b777d
    Froze current state as "STATE BEFORE: 'ugit restore 84f66c2cdffeee1aebb2a3244cc1e726615b777d'"
    State restored to "STATE BEFORE: 'ugit pull --rebase'" on Thu Mar 6 12:47:31 2014 -0800 (84f66c2cdffeee1aebb2a3244cc1e726615b777d)

    def ugit(git_action_sting):
      ffreeze(message="ugit #{git_action_string}")
      git(git_action_string)

    def ugit_restore(shaw):
      ffreeze_restore(shaw, command="ugit restore #{shaw}")

    def ugit_freeze_list():
      frreze_list()

# folderfreeze

Command line utilty to store snapshots of a directory.

    $ ffreeze "in the middle of a tough bug fix"
    Froze current state

    $ ffreeze "going for a burrito"
    Froze current state with message "going for a burrito"

    $ ffreeze list
    commit 84f66c2cdffeee1aebb2a3244cc1e726615b777d
    Author: Steve Krouse <steve@looker.com>
    Date:   Thu Mar 6 12:47:31 2014 -0800

        going for a burrito

    commit 95a21b1959c7a03f84de4c2cbb8b77c947998f65
    Author: Steve Krouse <steve@looker.com>>
    Date:   Thu Mar 6 11:35:20 2014 -0800

        in the middle of a tough bug fix

    $ ffreeze restore 84f66c2cdffeee1aebb2a3244cc1e726615b777d
    Froze current state as "STATE BEFORE: ffreeze restore 84f66c2cdffeee1aebb2a3244cc1e726615b777d"
    State restored to "going for a burrito" on Thu Mar 6 12:47:31 2014 -0800 (84f66c2cdffeee1aebb2a3244cc1e726615b777d)

