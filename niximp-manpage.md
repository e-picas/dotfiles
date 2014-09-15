Man:        niximp.sh Manual
Name:       *NIX in my pocket
Author:     Les Ateliers Pierrot
Date: 2013-11-09
Version: 0.0.0


## NAME

niximp - Bring your UNIX environment with you

## SYNOPSIS

**niximp.sh action [common options] [script options [=value]] --**

**niximp.sh**  [**-f**|**-i**|**-q**|**-v**]  [**-x**|**--dry-run**]  [**-p** | **--path** *=path*]  ...
    ... help  <action>  [**--less**]  [**--more**]
    -- 

## DESCRIPTION


## OPTIONS

*The following common options are supported:*

**-p**, **--path** =path
:   define the project directory path (default is `pwd` - the `path` argument must exist)

**-v**, **--verbose**
:   increase script verbosity 

**-q**, **--quiet**
:   decrease script verbosity, nothing will be written unless errors 

**-f**, **--force**
:   force some commands to not prompt confirmation 

**-i**, **--interactive**
:   ask for confirmation before any action 

**-x**, **--debug**
:   see debug infos

**--dry-run**
:   see commands to run but do not run them actually 

*The following internal actions are available:*

**help / usage**
:   See the help information about the script or an action.

:        niximp.sh  help  -[common options ...]  <action>  [--less]  [--more]  --

:   The `--less` option shows the help information using the `less` program. The `--more`
    option shows the help information using the `more` program. If both options are used,
    the 'less' program will be choosed preferabily.


## FILES

*niximp.sh*, *niximp*
:   The library source file ; this is the script name to call in command line ; it can be
    stored anywhere in the file system ; its relevant place could be `$HOME/bin` for a user
    or, for a global installation, in a place like `/usr/local/bin` (be sure to put it in
    a directory included in the global `$PATH`) ; the script must be executable for its/all
    user(s).

*vendor/*
:   This directory embeds the required third-party [Piwi Bash Library](https://github.com/atelierspierrot/piwi-bash-library).
    If you already have a version of the library installed in your system, you can over-write
    the library loaded (and skip the embedded version) re-defining the `DEFAULT_BASHLIBRARY_PATH`
    of the global configuration file.

## EXAMPLES

A "classic" usage of the script would be:

    niximp.sh action -p ../relative/path/to/concerned/project

To get an help string, run:

    niximp.sh -h OR niximp.sh action -h OR niximp.sh help action

To make a dry run before really executing the actions, use:

    niximp.sh action --dry-run ...

## LICENSE

The library is licensed under GPL-3.0 - Copyleft (c) Les Ateliers Pierrot
<http://www.ateliers-pierrot.fr/> - Some rights reserved. For documentation,
sources & updates, see <http://github.com/atelierspierrot/niximp>. 
To read GPL-3.0 license conditions, see <http://www.gnu.org/licenses/gpl-3.0.html>.

## BUGS

To transmit bugs, see <http://github.com/atelierspierrot/niximp/issues>.

## AUTHOR

**Les Ateliers Pierrot** <http://www.ateliers-pierrot.fr/>.

## SEE ALSO

piwi-bash-library(3)

