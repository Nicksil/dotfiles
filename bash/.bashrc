case $- in
    *i*) ;;
    *) return ;;
esac

source "$HOME/.bashenv"

alias ll="/bin/ls -alF"
alias la="/bin/ls -A"
alias l="/bin/ls -CF"
alias untar='tar -zxvf'

shopt -s cdspell
shopt -s checkwinsize
shopt -s cmdhist
shopt -s dotglob
shopt -s extglob
shopt -s histappend
shopt -s no_empty_cmd_completion
shopt -s progcomp

# These options only exist since Bash 4.0-alpha
if ((BASH_VERSINFO[0] >= 4)); then
    shopt -s dirspell
    shopt -s globstar
    # Available since 4.0, but only set it if >=4.1 due to bug:
    # <https://lists.gnu.org/archive/html/bug-bash/2009-02/msg00176.html>
    ((BASH_VERSINFO[1] >= 1)) && shopt -s checkjobs
    # Only available since 4.3
    ((BASH_VERSINFO[1] >= 3)) && shopt -s direxpand
fi

if [ -t 0 ]; then
    stty -ixon
fi

if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        source /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        source /etc/bash_completion
    elif [ -f /usr/local/etc/bash_completion ]; then
        source /usr/local/etc/bash_completion
    fi
fi

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        echo "color support"
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1="\u@\h \w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "
else
    PS1="\u@\h \w\$(parse_git_branch) $ "
fi

source /usr/local/bin/virtualenvwrapper.sh
