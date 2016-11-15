#!/usr/bin/env bash

_user="${1:-${HOME}}"
_global="${2:-/etc}"
_logfile="${3:-/home/startup-files-test.log}"

if [[ "$1" =~ ^--?h(elp)?$ ]]; then
    echo "usage: $0 [user-dir=$_user] [global-dir=$_global] [log-filepath=$_logfile]
  i.e. $0 /my/test/local/path
       $0 /my/test/local/path /my/test/global/path
       $0 $HOME /etc /tmp/my-test-logfile.log";
    exit 0
fi

if [ "$(id -u)" != "0" ]; then
    echo "you must run this script with root privileges..."
    exit 1
fi

#    $_global/security/pam_env.conf
declare -a startupfiles=(
    $_global/bash.bashrc
    $_global/bashrc
    $_global/csh.cshrc
    $_global/csh.login
    $_global/csh.logout
    $_global/environment
    $_global/profile
    $_global/sudoers
    $_global/zprofile
    $_global/zshenv
    $_global/zshrc
    $_user/.bashrc
    $_user/.bash_login
    $_user/.bash_logout
    $_user/.bash_profile
    $_user/.cshrc
    $_user/.environment
    $_user/.kshrc
    $_user/.login
    $_user/.logout
    $_user/.pam_environment
    $_user/.profile
    $_user/.zshrc
    $_user/.zlogin
    $_user/.zlogout
    $_user/.zprofile
);
for _f in "${startupfiles[@]}"; do
    echo "> preparing $_f..."
    echo "echo \"\$(date +'[%Y-%m-%d %H:%M:%S]') > hello from $_f\" >> $_logfile ;" >> "$_f" ;
done
touch $_logfile
chmod 777 $_logfile

cat <<'EOT'

OK - Startup test files are ready and will write their names each time they are loaded
in configured logfile.

Now you should:
-   create X new users, each with a different shell (bash, zsh and csh for instance)
-   login with each user on a desktop session
-   login with each user on a terminal (from the desktop session)
-   run a script for each shell from that terminal session
-   run a script for each shell from out of the terminal session
-   logout from the terminal session
-   logout from the desktop session

You can include some "flags" in the log file (to retain who and what is done) by running:
    echo "my flag text" >> /path/to/logfile.log

EOT
