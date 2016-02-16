dotfiles
========

My personal *NIX dotfiles, licensed under CC BY-NC-SA 4.0 <http://creativecommons.org/licenses/by-nc-sa/4.0/>.
Feel free to use these files as a base for your own dotfiles by [forking the repo](http://help.github.com/articles/fork-a-repo).

This is largely inspired by <http://dotfiles.github.io/>.

In addition, my personal binary scripts are hosted at <http://github.com/e-picas/binaries>.

Installation
------------

Clone the repo:

    git clone https://github.com/e-picas/dotfiles.git ~/dotfiles

Launch installer (fully interactive):

    ./path/to/clone/install.sh

To see installer usage, run:

    ./path/to/clone/install.sh -h

Usage
-----

List of different filesystem treatments:

`<filename>.model`
:   this identifies a file containing some tags or fields to full fill ; this kind of file is
    hard copied in its final place and then opened in an editor to let you fill required tags

`<filename>.enc`
:   this identifies an encrypted file ; this kind of file is hard copied to its final place and
    then decrypted with your password (prompted each time)

`<dirname>.dir`
:   this indifies a directory that must be treated "as-is" ; it will be linked or copied (with
    its contents of course) without analyzing its contents

`<filename>`
:   any other file is treated following the default action in use (link or hard copy)


List of local directories and their handling:

`home/`
:   the place for the *dotfiles* ; they are finally linked or copied at the root of the `<target>/`
    directory

`bin/`
:   the place for the binary scripts ; they are finally linked or copied to the `<target>/bin/`
    directory

`keys/`
:   the place for the various personal keys you use ; they should be stored encrypted and will
    be finally copied and decrypted in the relative sub-directory of the `<target>/` directory ;
    the contents of this directory are considered "per-file", which means that only files are
    copied, in the path constructed relative to `<target>/` (`keys/.ssh/my_rsa_key.encrypted`
    will be copied into `<target>/.ssh/my_rsa_key`)

`data/`
:   the place for any other contents ; they are finally linked or copied to concerned `<target>/<path>/`
    directory ; to link or copy a whole directory, use the `.dir` suffix ; examples:
    -   `data/toughts/my-thought.txt` will be linked to `<target>/toughts/my-thought.txt`
    -   `data/notes.dir/` will be linked to `<target>/notes/`

Best practices
--------------

The best practice is to use GIT submodules to store your binaries (and any other stuff you need). This
way, if you linked interesting contents somewhere in your clone, you are able to be fully updated without
modifying anything in your clone byt the submodule revision.

Another best practice for *dotfiles* is to make each of them include a `<dotfile>_alt` file (if it is present)
to allow "per-device" customizations.

