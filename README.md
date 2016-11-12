dotfiles
========

My personal *NIX dotfiles, licensed under CC BY-NC-SA 4.0 <http://creativecommons.org/licenses/by-nc-sa/4.0/>.
Feel free to use these files as a base for your own dotfiles by [forking the repo](http://help.github.com/articles/fork-a-repo).

This is largely inspired by <http://dotfiles.github.io/>.

In addition, my personal binary scripts are hosted at <http://github.com/e-picas/binaries>.

A set of various documentations is proposed in the `docs/` directory of this package.

## How-To

### Installation

Clone the repo:

    git clone https://github.com/e-picas/dotfiles.git ~/dotfiles

Launch installer (fully interactive):

    ./path/to/clone/install.sh

To see installer usage, run:

    ./path/to/clone/install.sh -h

### Usage

The rules are quite simple:

-   all "dotfiles" are stored in the `home/` directory and are to be symlinked or copied
    in the UNIX user's `$HOME`
-   when it is possible, any dotfile will try to include a `_alt` suffixed same file used
    for "per-device" configurations
-   any file with a `.model` suffix contains masks like `@MASK@` that needs to be filled 
    with a value (tokens mostly)
-   a collection of dotfiles are loaded from the `$HOME/.bashrc.d/` directory as shell scripts ;
    they must be named like `<filename>.sh` and are loaded by the default `.bashrc` file of
    this package
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
    | .bashrc.d/dotfile.sh      -> as a symlink to path/to/clone/home/.bashrc.d/dotfile.sh
    | .bashrc.d/dotfile.sh      -> as a hard copy of path/to/clone/home/.bashrc.d/dotfile.sh.model
    |
    | bin/cmd       -> as a symlink to path/to/clone/bin/cmd
    |
    | notes/        -> as a symlink to path/to/clone/notes/
    |

## Special features

### Functions

#### Notepad

My `.bash_functions` embeds a simple command-line "notepad" handler to list, read and write
some simple text notes in `txt` files stored in the `notes/` directory. A special `cheatsheets/`
sub-dir stores my cheat-sheets as plain text.

To use it, run:

    note            # this will show the 'notes' help
    cheatsheet      # this will show the 'cheat-sheets' help

These commands work with the `NOTESDIR` env var that is defined by `.bashrc` and defaults to `$HOME/notes/`.

#### Encryption

My `.bash_functions` also embeds a (very) simple encryption set of functions to encrypt/decrypt strings or files.
It uses the default UNIX [Open SSL](http://www.openssl.org/) command for encryption with a password prompted each time.
Keep in mind that you NEED to remind your password.

To use it, run:

    encrypt_string "my string to encrypt"
    decrypt_string "encrypted_string"
    encrypt_file file-to-encrypt.ext
    decrypt_file encrypted-file.enc

This can be useful, for instance, for a mysql connection alias:

    alias mysqltest='p=$(decrypt_string U2FsdGVkX19FuOPF3w3+GG8E4f3+v042BguJw7vetA8=) && mysql -uUSER -p$p DB'

### Special directories

My `.bashrc` will (always) try to create the following directories:

    $HOME/backups/  : loaded in `BACKUPDIR` env var
    $HOME/tmp/      : created only if the `TMPDIR` env var is not defined


### Notes

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

I also include a hard copy of the `git-completion` script written by [*Shawn O. Pearce*](http://spearce.org).
His script is included in recent GIT official distributions but I used to include it as a
dotfile at `$HOME/.bashrc.d/git-completion`. It is sourced by my `bashrc_git.sh` (stored in `home/alt/`)
sourced itself by my global `.bashrc`.

----

Author: Pierre Cassat - @picas (me at picas dot fr)

Original sources: <http://github.com/e-picas/dotfiles.git>

License: CC BY-NC-SA 4.0 <http://creativecommons.org/licenses/by-nc-sa/4.0/>
