case $- in
    *i*) ;;
    *) return ;;
esac

source "$HOME/.bashenv"

alias busy="cat /dev/urandom | hexdump -C | grep 'ca fe'"
# grep/GNU grep has deprecated the use of GREP_OPTIONS.
# The following replaces `export GREP_OPTIONS='--color=auto'`
alias grep="grep --color=auto"
# The following supresses the deprecation message.
unset GREP_OPTIONS
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

# Find (and source) bash completions
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        source /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        source /etc/bash_completion
    elif [ -f /usr/local/etc/bash_completion ]; then
        source /usr/local/etc/bash_completion
    elif [ -d /usr/local/etc/bash_completion.d ]; then
        for i in /usr/local/etc/bash_completion.d/*; do
            . "${i}"
        done
    fi
fi

extract () {
    if [ -f "${1}" ]; then
        case "${1}" in
            *.tar.bz2)   tar xvjf "${1}"  ;;
            *.tar.gz)    tar xvzf "${1}"  ;;
            *.bz2)       bunzip2 "${1}"   ;;
            *.rar)       unrar x "${1}"   ;;
            *.gz)        gunzip "${1}"    ;;
            *.tar)       tar xvf "${1}"   ;;
            *.tbz2)      tar xvjf "${1}"  ;;
            *.tgz)       tar xvzf "${1}"  ;;
            *.xz)        unxz "${1}"      ;;
            *.zip)       unzip "${1}"     ;;
            *.Z)         uncompress "${1}";;
            *.7z)        7z x "${1}"      ;;
            *) echo "don't know how to extract '$1'...";;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ "$color_prompt" = yes ]; then
    PS1="\u@\h \w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "
else
    PS1="\u@\h \w\$(parse_git_branch) $ "
fi

source /usr/local/bin/virtualenvwrapper.sh
