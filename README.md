dotfiles
========

My personal *NIX dotfiles, licensed under CC BY-NC-SA 4.0 <http://creativecommons.org/licenses/by-nc-sa/4.0/>

@pierowbmstr (me at picas dot fr)

<http://github.com/pierowbmstr/dotfiles.git>

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
