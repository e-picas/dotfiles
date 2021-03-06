Startup files
=============


Some first definitions/reminders:

-   the `rc` filename suffix stands for "resource configuration"
-   the `.d` extension used for some configuration directories stands for "directory" ; it is often a directory
    associated with a configuration file which includes its contents
-   the user *shell* is the default shell used by the user ; it is mostly *Bash* (on Ubuntu for instance)
    but can be any other shell like the *C shell* (`csh`), the *Korn shell* (`ksh`) etc
-   an *interactive shell* is created when you log in, on a console, over ssh etc
-   a *non-interactive shell* is created when no interaction is waited, like running a script from an interactive shell session
-   a *login shell* is made each time a user identification is required (interactive shells, opening a new desktop manager session etc)
-   a *non-login shell* is made each time a script is run from an existing login shell session (login is already done)

The following files are loaded by most systems:

-   for *interactive login shell session* (each time you open a new user session on a computer) :
    -   `/etc/profile`
    -   `~/.bash_profile`
    -   `~/.bash_login`
    -   `~/.profile`
-   for *interactive non-login shell session* (each time you create a new session on a terminal
    or an ssh connection) :
    -   `~/.bashrc` (the file indicated by the `$ENV` variable)
-   for *non-interactive non-login shell session* (each time a shell script is running) :
    -   `~/.bashrc` (the file indicated by the `$BASH_ENV` variable)

All the files proposed in this package assumes your shell is Bash. To set it, use:

    # be sure to use bash as default shell
    setenv SHELL /bin/bash
    exec /bin/bash --login

Review of configuration files:

`/etc/profile` & `/etc/profile.d/*.sh`
:   System-wide `.profile` file for the Bourne shell (sh(1)) and Bourne compatible shells (bash(1), ksh(1), ash(1), ...).

`/etc/bashrc` or `/etc/bash.bashrc`
:   System-wide `.bashrc` file for interactive bash(1) shells.

`/etc/environment` & `.environment`
:   These are system-wide or user-wide variables definitions. They are NOT scripts and should be written
    on an INI model: `VAR=VAL`

`/etc/dircolors` or `.dircolors`
:   Colors used by the `ls` command. To generate a model, use:

        dircolors -p > ~/.dircolors

`/etc/sudoers`
:   Special *sudo* users configurations on Ubuntu based systems.

`/etc/skel/*`
:   Default skeleton used for user home creation.

`.profile`
:   This one is loaded when the display manager starts a session (when you log in a new computer
session). It is loaded for all shells.

`.cshrc`
:   This one is loaded for each C shell new non-login session (upon terminal for instance)

`.login`
:   This one is the startup file for C shell sessions, run only one when you log in.

`.bashrc`
:   This one is a shell script loaded for each new non-login session (upon terminal for instance)

`.bash_profile`
:   This one is a shell script run only once when you log in. 

`.bash_logout`
:   This one is a shell script run when user exits from an interactive login shell. 

The common `.bashrc` file proposed here will try to load any `*.sh` script stored in a `~/.bashrc.d/`
directory. This can let you separate features in distinct files or quickly add configuration settings
for a device. The files with a `~` suffix will be ignored.

----

Author: Pierre Cassat - @picas (me at picas dot fr)

Original sources: <http://github.com/e-picas/dotfiles.git>

License: CC BY-NC-SA 4.0 <http://creativecommons.org/licenses/by-nc-sa/4.0/>
