dotfiles
========

My personal *NIX dotfiles, licensed under CC BY-NC-SA 4.0 <http://creativecommons.org/licenses/by-nc-sa/4.0/>

This is largely inspired by <http://dotfiles.github.io/>.


## How-To

The rules are quite simple:

-   all "dotfiles" are stored in the `home/` directory and are to be symlinked or copied
    in the UNIX user's `$HOME`
-   when it is possible, any dotfile will try to include a `_alt` suffixed same file used
    for "per-device" configurations (these files are excluded from version control)
-   any file with a `.model` suffix needs to be filled with a value (tokens mostly)
-   all binaries of the `bin/` directory are to be copied or symlinked in the UNIX user's
    `$HOME/bin/` and are themselves symlinks to git submodules stored in the `modules/`
    directory (so I can always be up-to-date)
-   the `notes/` directory stores my personal notes, handled by the `note` bash function

The final install may be something like:

    [$HOME]
    |
    | .dotfile      -> as symlinks to path/to/clone/home/.dotfile
    | .dotfile      -> as a hard copy of path/to/clone/home/.dotfile.model
    |
    | bin/modules/  -> as a symlink to path/to/clone/modules/
    | bin/cmd       -> as a symlink to $HOME/modules/...
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

These commands work with the `NOTESDIR` env var that is defined by `.bashrc`.

### Special directories

My `.bashrc` will (always) create the following directories:

    $HOME/backups/  : loaded in `BACKUPDIR` env var
    $HOME/tmp/      : created only if the `TMPDIR` env var is not defined

----

Author: Pierre Cassat - @pierowbmstr (me at picas dot fr)

Original sources: <http://github.com/pierowbmstr/dotfiles.git>

License: CC BY-NC-SA 4.0 <http://creativecommons.org/licenses/by-nc-sa/4.0/>
