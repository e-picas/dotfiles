dotfiles
========

My personal *NIX dotfiles, licensed under CC BY-NC-SA 4.0 <http://creativecommons.org/licenses/by-nc-sa/4.0/>.

This is largely inspired by <http://dotfiles.github.io/>.

In addition, my personal binary scripts are hosted at <http://github.com/piwi/binaries>.


## How-To

### Installation

Clone the repo:

    git clone https://github.com/piwi/dotfiles.git ~/dotfiles

Launch installer:

    ./path/to/clone/install.sh

### Usage

The rules are quite simple:

-   all "dotfiles" are stored in the `home/` directory and are to be symlinked or copied
    in the UNIX user's `$HOME`
-   when it is possible, any dotfile will try to include a `_alt` suffixed same file used
    for "per-device" configurations
-   any file with a `.model` suffix contains masks like `@MASK@` that needs to be filled 
    with a value (tokens mostly)
-   all binaries of the `bin/` directory are to be copied or symlinked in the UNIX user's
    `$HOME/bin/` and are themselves symlinks to git submodules stored in the `modules/`
    directory (so I can always be up-to-date)
-   the `notes/` directory stores my personal notes, handled by the `note` bash function

The final install may be something like:

    [$HOME]
    |
    | .dotfile      -> as a symlink to path/to/clone/home/.dotfile
    | .dotfile      -> as a hard copy of path/to/clone/home/.dotfile.model
    |
    | bin/cmd       -> as a symlink to path/to/clone/bin/cmd
    |
    | notes/        -> as a symlink to path/to/clone/notes/
    |

## Special features

### Functions

My `.bash_functions` embeds a simple command-line "notepad" handler to list, read and write
some simple text notes in `txt` files stored in the `notes/` directory. A special `cheatsheets/`
sub-dir stores my cheat-sheets as plain text.

To use it, run:

    note            # this will show the 'notes' help
    cheatsheet      # this will show the 'cheat-sheets' help

These commands work with the `NOTESDIR` env var that is defined by `.bashrc` and defaults to `$HOME/notes/`.

### Special directories

My `.bashrc` will (always) try to create the following directories:

    $HOME/backups/  : loaded in `BACKUPDIR` env var
    $HOME/tmp/      : created only if the `TMPDIR` env var is not defined


## Notes

I use the [lesspipe](http://www-zeuthen.desy.de/~friebel/unix/lesspipe.html) tool by *Wolfgang Friebel*
to view some special files with `less`. As the original repository is under SVN and hosted by 
[SourceForge](http://sourceforge.net/projects/lesspipe/), I use the internal `git-svn` command
to track the original SVN sources on branch `lesspipe` of this actual (GIT) package and define
this branch as a submodule. Corresponding SVN config (for fresh clones):

    [svn-remote "svn"]
        url = svn://svn.code.sf.net/p/lesspipe/code
        fetch = trunk:refs/remotes/trunk
        branches = branches/*:refs/remotes/*
        tags = tags/*:refs/remotes/tags/*


I mostly followed this tutorial to build the git branch tracking the svn repo and use it 
as a submodule: <http://fredericiana.com/2010/01/12/using-svn-repositories-as-git-submodules/>.


----

Author: Pierre Cassat - @pierowbmstr (me at e-piwi dot fr)

Original sources: <http://github.com/piwi/dotfiles.git>

License: CC BY-NC-SA 4.0 <http://creativecommons.org/licenses/by-nc-sa/4.0/>
