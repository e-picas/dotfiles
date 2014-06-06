#
# .bash_functions
# by @pierowbmstr (me at picas dot fr)
# <http://github.com/pierowbmstr/dotfiles.git>
# (personal) file licensed under CC BY-NC-SA 4.0 <http://creativecommons.org/licenses/by-nc-sa/4.0/>
#

#
# moves file to ~/.Trash
# (use instead of rm)
#
trash(){
    if [ $# -eq 0 ]
    then
        echo "Usage: trash <FILE> ..."
        return 1
    fi
    local DATE=$(date +%Y%m%d)
    [ -d "${HOME}/.Trash/${DATE}" ] || mkdir -p ${HOME}/.Trash/${DATE};
    for FILE in "$@"
    do
        mv "${FILE}" "${HOME}/.Trash/${DATE}"
        echo "${FILE} trashed!"
    done
}

#
# get a timestamp
#
timestamp() {
    date +"%T"
}

#
# cf. <http://www.admin-linux.fr/?p=1965>
# can take a timestamp as argument
#
envdate() {
    [ ! -z ${1} ] && date -d @${1} +'%d/%m/%Y (%A) %X (UTC %z)' || date +'%d/%m/%Y (%A) %X (UTC %z)';
}

#
# Run a command quietly. Suppresses all output.
#
quietly() {
    "$@" > /dev/null 2>&1
}

#
# Email me a short note
#
emailme(){
    if [ $# -eq 0 ]
    then
        echo "Usage: emailme [text]"
        return 1
    fi
    mailx -s "$@" $USER <<< "$@"
    echo "Sent email"
}

#
# fast find, using globstar
#
fastfind () {
    ls -ltr **/$@
}

#
# Make a directory and change to it
#
mkcd() {
  if [ $# -ne 1 ]
  then
        echo "Usage: mkcd <dir>"
        return 1
  else
        mkdir -p "$@" && cd "$_"
  fi
}

#
# cd to a directory and ls
#
cdls() {
    cd "$@" && ls -ltr
}

#
# prints a ruler the size of the terminal window
#
ruler() {
    for s in '....^....|' '1234567890'
    do
        w=${#s}
        str=$( for (( i=1; $i<=$(( ($COLUMNS + $w) / $w )) ; i=$i+1 )); do echo -n $s; done )
        str=$(echo $str | cut -c -$COLUMNS)
        echo $str
    done
}

#
# Prints out a long line. Useful for setting a visual flag in your terminal.
#
flag(){
    echo -e "\e[1;36m[==============="$@"===\
             ($(date +"%A %e %B %Y %H:%M"))\
             ===============]\e[m";
}

#
# Backup file(s)
#
dobackup(){
    if [ $# -lt 1 ]
    then
        echo "Please supply a file to backup"
        return 1
    fi
    date=`date +%Y%m%d-%H%M`
    for i in "$@"
    do
        echo Backed up $i to $i.$date
        cp $i $i.$date
    done
}

#
# add the BOM marker in a file's header
addbom(){
    if [ $# -eq 0 ]; then
        echo "usage: addbom <working_dir/file> [<mask=*.php>]"
        exit 1
    fi
    _DIR="$1"
    _MASK="${2:-*.php}"
    for _f in `find "${_DIR}" -type f -name "${_MASK}"`; do
        echo ${_f}
        _f_tmp=${_f}.tmp
        printf '\xEF\xBB\xBF' > ${_f_tmp}
        cat ${_f} >> ${_f_tmp}
        rm -f ${_f} && mv ${_f_tmp} ${_f}
    done
}

#
# Extract an archive of any type
#
extract () {
   if [ $# -lt 1 ]
   then
       echo "Usage: extract <file>"
       return 1
   fi
   if [ -f $1 ] ; then
       case $1 in
           *.tar.bz2) tar xvjf $1 ;;
           *.tar.gz) tar xvzf $1 ;;
           *.bz2) bunzip2 $1 ;;
           *.rar) unrar x $1 ;;
           *.gz) gunzip $1 ;;
           *.tar) tar xvf $1 ;;
           *.tbz2) tar xvjf $1 ;;
           *.tgz) tar xvzf $1 ;;
           *.zip) unzip $1 ;;
           *.war|*.jar) unzip $1 ;;
           *.Z) uncompress $1 ;;
           *.7z) 7z x $1 ;;
           *) echo "don't know how to extract '$1'..." ;;
       esac
   else
       echo "'$1' is not a valid file!"
   fi
}

#
# Creates an archive
#
tarball () {
  if [ "$#" -ne 0 ] ; then
    FILE="$1"
    case "$FILE" in
      *.tar.bz2|*.tbz2) shift && tar cvjf "$FILE" "$@" ;;
      *.tar.gz|*.tgz) shift && tar cvzf "$FILE" "$@" ;;
      *.tar) shift && tar cvf "$FILE" "$@" ;;
      *.zip) shift && zip -r "$FILE" "$@" ;;
      *.rar) shift && rar "$FILE" "$@" ;;
      *.7z) shift && 7zr a "$FILE" "$@" ;;
      *) echo "'$1' cannot be rolled via roll()" ;;
    esac
  else
    echo "usage: tarball [file] [contents]"
  fi
}

#
# print duplicate lines in file
#
dupes() {
    sort "$@" | uniq -d
}

#
# read a csv file
#
csv() {
    if [ $# -eq 0 ]
    then
        echo "Usage: csv [delim] filename"
        exit 1
    fi
    if [ $# -gt 1 ]
    then
        delimiter="$1"
        shift
    else
        delim=';'
    fi
    awk -F "$delim" '{if(NR==1)split($0,arr);else for(i=1;i<=NF;i++)print arr[i]":"$i;print "";}' "$1"
}

#-------------------------------
# String manipulation functions
#-------------------------------

#
# substring word start [length]
#
substring(){
    if [ $# -lt 2 ]; then
        echo "Usage: substring word start [length]"
        return 1
    fi
    if [ -z $3 ]
    then
        echo ${1:$2}
    else
        echo ${1:$2:$3}
    fi
}

#
# length of string
#
length(){
    if [ $# -lt 1 ]; then
        echo "Usage: length word"
        return 1
    fi
    echo ${#1}
}

#
# replace part of string with another
#
replace(){
    if [ $# -ne 3 ]; then
        echo "Usage: replace string substring replacement"
        return 1
    fi
    echo ${1/$2/$3}
}

#
# replace all parts of a string with another
#
replaceAll(){
    if [ $# -ne 3 ]; then
        echo "Usage: replace string substring replacement"
        return 1
    fi
    echo ${1//$2/$3}
}

#
# find index of specified string
#
index(){
    if [ $# -ne 2 ]; then
        echo "Usage: index string substring"
        return 1
    fi
    expr index $1 $2
}

#
# Upper-case
#
upper(){
    if [ $# -lt 1 ]; then
        echo "Usage: upper word"
        return 1
    fi
    echo ${@^^}
}

#
# Lower-case
#
lower(){
    if [ $# -lt 1 ]; then
        echo "Usage: lower word"
        return 1
    fi
    echo ${@,,}
}

#
# surround string with quotes, for example.
#
surround(){
   if [ $# -ne 2 ]
   then
     echo "Usage: surround string surround-with e.g. surround hello \\\""
     return 1
   fi
   echo $1 | sed "s/^/$2/;s/$/$2/" ;
}

#-------------------------------
# Machine info
#-------------------------------

#
# load in _IP & _ISP
#
getip () {
    export _IP=$(ifconfig | awk '/inet / { print $2 } ' | sed -e s/addr:// 2>&-)
    export _ISP=$(ifconfig | awk '/P-t-P/ { print $3 } ' | sed -e s/P-t-P:// 2>&-)
}

#
# device infos
#
myinfos () {
    echo
    echo -e "# `envdate`"
    echo -e "current user:     `whoami`"
    echo -e "system infos:     `uname -n`"
    echo -e "device infos:     `uname -v`"
    echo -e "device stats:     `uptime`"
    getip;
    echo -n "IP address:       "; echo $_IP
    echo -n "ISP address:      "; echo $_ISP
    echo -e "#"
    echo
}

#-------------------------------
# Simple notepad
#-------------------------------

note(){
    if [ -z $NOTESDIR ]
    then
        echo "NOTESDIR not defined, can't use notepad"
        return 1
    fi
    if [ $# -eq 0 ]
    then
        echo "Usage:   note ls"
        echo "           list all notes"
        echo "Usage:   note <note name>"
        echo "           read a note"
        echo "Usage:   note <note name> <action (+/-)> [note text ...]"
        echo "           action +  to write a note"
        echo "           action ++ to write a note with date header"
        echo "           action -  to clear note"
        echo "           action -- to remove a note"
        echo "           action vi to open a note with EDITOR"
        echo "NOTE : use the 'cheatsheet' cmd for cheat-sheets"
        return 1
    fi
    case $1 in
        ls) ls $NOTESDIR && return 0;;
        *) notestack=$1; shift;;
    esac
    append=1
    action=read
    if [ "$notestack" = '-' ]
    then
        notestack=`date +"%d-%m-%y"`
    fi
    if [ "$1" = '++' ]
    then
        action=add
        append=0
        shift
    elif [ "$1" = '+' ]
    then
        action=add
        shift
    elif [ "$1" = '--' ]
    then
        rm $NOTESDIR/$notestack
        echo note $notestack deleted
        return 0
    elif [ "$1" = '-' ]
    then
        echo '' > $NOTESDIR/$notestack
        echo note $notestack cleared
        return 0
    elif [ "$1" = 'vi' ]
    then
        $EDITOR $NOTESDIR/$notestack
    fi
    if [ "$action" = 'read' ]
    then
        cat $NOTESDIR/$notestack
    else
        takenote=$*
        if [ $append -eq 0 ]
        then
            echo                                  >> $NOTESDIR/$notestack
            echo "## `date '+%T, %a %d/%m/%y'`"   >> $NOTESDIR/$notestack
            echo       '------------------------' >> $NOTESDIR/$notestack
        fi
        echo $takenote >> $NOTESDIR/$notestack
        echo note added to $notestack
    fi
}

cheatsheet() {
    if [ $# -eq 0 ]
    then
        echo "Usage:   cheatsheet <note name>"
        echo "           read a cheatsheet"
        echo "Usage:   cheatsheet <note name> [note text ...]"
        echo "           write a cheatsheet or add content in it"
        return 1
    fi
    _name="cheatsheets/${1}-cheatsheet.txt"
    shift
    note "${_name}" "$*"
}

# user per-device external files
[ -r ${HOME}/.bash_functions_alt ] && source ${HOME}/.bash_functions_alt;

# Endfile
# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh
