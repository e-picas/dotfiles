*NIX in my pocket
=================

Bring your env with you dude ;)

## How-to

1   clone original repo

    git clone http://private.git.ateliers-pierrot.fr/niximp.git

2   launch niximp

    cd niximp && ./niximp.sh

## What is done?

This will copy all concerned files from your clone to current environment. Some special treatments
are done as follow:

-   any `FILENAME.run` file will be executed in concerned directory (`$HOME/bin` for a file
    placed in `niximp/bin` for instance) ; this allows you to make some clones of various
    repositories for instance ; complementarily, any file named `FILENAME.update.run` will be
    stored in a special `$HOME/.updates/` directory to allow you to easily update any CSV
    clone

-   any `FILENAME.model` will be parsed with NIXIMP environment variables ; they are also stored
    as templates (see below) to allow you to use them with one of your "identity"

-   any `FILENAME.template` will be stored "as is" in your `$HOME/.templates/` directory ; this
    can be useful to remain some template files you often use


## Structure

NIXIMP files are separated in "pools" by file type or file scope ; each of them can equaly
accept "run", "model" or "template" files as described above:

-   `dotfiles/`: all dotfiles to install in your `$HOME/` directory ; these are mostly
    configuration files

-   `bin/`: all binaries to install in your `$HOME/bin/` directory ; these may be your
    common scripts ; these scripts will be copied as symbolic links in their equivalent 
    without extension if they had one and will be made executable (`a+x`)

-   `lib/`: all libraries to install in your `$HOME/bin/lib/` directory ; these may be
    your commonly used external libraries

-   `docs/`: some documents you want to always have with you

-   `etc/`: this will store useful and common configuration files (which will be tried to
    install in global `/etc/`)

-   `keys/`: all usable keys or certificates (SSH or SSL)

-   `identities/`: a special directory which can be used to store some infos for each of your
    "identities" ; each "identity" is a sub-directory named with a uniq shortcut, the identity
    ID, containing some information files describing the identity infos as shell variables ; these
    identities will be stored in a `$HOME/.identities/` directory after confirmation (as these
    are quite sensible infos)


## SSL

Copy the certificates:

    cp self-server.crt /usr/local/apache/conf/ssl.crt/server.crt
    cp self-server.key /usr/local/apache/conf/ssl.key/server.key

Add to virtual host:

    SSLEngine on
    SSLCertificateFile /usr/local/apache/conf/ssl.crt/server.crt
    SSLCertificateKeyFile /usr/local/apache/conf/ssl.key/server.key
    SetEnvIf User-Agent ".*MSIE.*" nokeepalive ssl-unclean-shutdown


## HT password

Generate a `htpasswd` file:

    htpasswd file_path user_name
    // password will be prompted

All-in-one:

    htpasswd -cbm htpasswd.test test test

-   'c' option: create the file or over-write it (truncate)
-   'b' option: read the password from command line
-   'm' option: use MD5 algorithm

Create file "if so":

    MYPSWDFILE="htpasswd.txt"
    MYUSERNAME="test"
    MYUSERPASS="test"
    [ -f $MYPSWDFILE ] && htpasswd -bm "$MYPSWDFILE" "$MYUSERNAME" "$MYUSERPASS" || htpasswd -cbm "$MYPSWDFILE" "$MYUSERNAME" "$MYUSERPASS";

Format of simple htpasswd file:

    # this is a comment
    username:encodedpass
    username2:encodedpass

Format of group htpasswd file:

    # this is a comment
    groupname: username username2 

Define a "per-user" auth:

    AuthType Basic
    <IfModule mod_auth_digest>
        AuthType Digest
    </IfModule>
    AuthName "Restricted Area"
    AuthBasicProvider file
    AuthUserFile /path/to/passwords/file
    Require user username

Use groups:

    AuthGroupFile /path/to/groups/passwords
    Require group groupname


## Install SSH keys

Generate a key:

    ssh-keygen -t rsa

Transmit the key to a server:

    ssh-copy-id -i ~/.ssh/id_rsa.pub titi@toto.host.org

Old way (if 'ssh-copy-id' is not available):

    scp ~/.ssh/id_dsa.pub server:.ssh/authorized_keys2
    cat foo.pub | ssh server 'sh -c "cat - >> ~/.ssh/authorized_keys2"'

Full setup with per user restrictions:
    
    echo "command=\"echo I'm `/usr/bin/whoami` on `/bin/hostname`\",no-port-forwarding,no-X11-forwarding,no-agent-forwarding" > tempfile
    cat foo.pub >> templfile
    cat tempfile | ssh server 'sh -c "cat - >>~/.ssh/authorized_keys2"'

Aliasing an ssh connection:
    
    alias sshtoto='ssh titi@toto.host.org'

Test ...


## FAQ

### Can I maintain my personal copy of Niximp under version control and get next updates?

Yes. Niximp is designed to allow you to make your own, personal version of niximp, stored on
a server of your choice (a secret one preferabily) and still be able to merge base niximp code
updates. To do so, you just need to make a fork of the original repository, store it where you
want, put any of your personal files under VCS in it, and run the following when you want to
update your niximp binary:

    git remote add original https://github.com/atelierspierrot/niximp.git
    git fetch original
    git checkout master && git merge original/master


### Can I put `niximp.sh` in my user's "bin/" directory or global "/bin/"?

Yes. But you will need to let the `piwi-bash-library.sh` file in the same directory as `niximp.sh`.
To move niximp and install it for a user or globally, run:

    cp niximp.sh $HOME/bin/
    cp deps/piwi-bash-library.sh $HOME/bin/

If you prefer to call "niximp" (with no nextension), you can do:

    ln -s $HOME/bin/niximp.sh niximp

