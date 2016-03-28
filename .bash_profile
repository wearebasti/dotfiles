#  ---------------------------------------------------------------------------
#
#  Description:  This file holds all my BASH configurations and aliases
#
#  Sections:
#  1.   Environment Configuration
#  2.   Make Terminal Better (remapping defaults and adding functionality)
#  3.   File and Folder Management
#  4.   Searching
#  5.   Process Management
#  6.   Networking
#  7.   System Operations & Information
#  8.   Web Development
#  9.   Reminders & Notes
#   -------------------------------
#   1.  ENVIRONMENT CONFIGURATION
#   -------------------------------
#   Set Default Editor
#   ------------------------------------------------------------
    export EDITOR=/usr/bin/vim
    
# DOCKER github-rate limit upgrade
    export HOMEBREW_GITHUB_API_TOKEN=4fa13b88308cc7fff37629506bb90ec3fae88091

# following the INSTALL.md file from stylight-core:
    export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH
    export WORKON_HOME=$HOME/.virtualenvs
    source /usr/local/bin/virtualenvwrapper.sh

# Making the rabbitmq-server-scripts available:
    export PATH=$PATH:/usr/local/sbin:/Users/seitzs/bin
#   Add color to terminal
#   (this is all commented out as I use Mac Terminal Profiles)
#   from http://osxdaily.com/2012/02/21/add-color-to-the-terminal-in-mac-os-x/
#   ------------------------------------------------------------
#   export CLICOLOR=1
  # export LSCOLORS=ExFxBxDxCxegedabagacad
#   export LSCOLORS=GxFxCxDxBxegedabagaced
#   -----------------------------
#   2.  MAKE TERMINAL BETTER
#   -----------------------------

source ~/.aliases

cd() { builtin cd "$@"; ls; }               # Always list directory contents upon 'cd'

#   extract:  Extract most know archives with one command
#   ---------------------------------------------------------
    extract () {
        if [ -f $1 ] ; then
          case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *.zip)       unzip $1       ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
             esac
         else
             echo "'$1' is not a valid file"
         fi
    }

# Copied from Andre
ccache="/usr/lib/ccache/bin:"
PATH="~/bin:${PATH}"
old_IFS="$IFS"; IFS=":"; newpath=
for i in $PATH; do
    if [ "$i" = "$ccache" ]; then
        ccache=
    fi
    if [ "$i" = "~/bin" ]; then
        i="${HOME}/bin"
    fi
    newpath="${newpath:+${newpath}:}${i}"
done
IFS="$old_IFS"
PATH="${ccache}${newpath}"
export PATH
unset newpath
unset ccache
unset old_IFS
unset i

umask 022


c() {
    local bold=
    [ "${2}" = bold ] && bold="01;"

    echo -e "\033[${bold}${colors["$1"]}m"
}

pc() {
    local bold=
    [ "${2}" = bold ] && bold="01;"

    echo "\[\033[${bold}${colors["$1"]}m\]"
}

parse_git_repo() {
    local repo stashc

    if git rev-parse --git-dir >/dev/null 2>&1; then
        stashc="$(git stash list 2>/dev/null | wc -l)"
        if [ ${stashc} = 0 ]; then
            stashc=
        else
            stashc=" [#${stashc}]"
        fi

        repo="$(git branch 2>/dev/null | sed -n '/^\*/s/^\* //p')"
        if git diff --ignore-submodules=dirty --exit-code --quiet 2>/dev/null >&2; then
            if git diff --ignore-submodules=dirty --exit-code --cached --quiet 2>/dev/null >&2; then
                repo="$(pc green)${repo}$(pc reset)"
            else
                repo="$(pc cyan)"'!'"${repo}$(pc reset)"
            fi
        else
            repo="$(pc red)"'!'"${repo}$(pc reset)"
        fi

        echo " ${repo}${stashc}"
    fi
}

prompt_command() {
    PS1="\[$(tput sgr0)\]\[$(tput setaf 4)\]\[$(tput bold)\]\u@\h\[$(tput sgr0)\]\[$(tput setaf 4)\]\[$(tput bold)\]$(parse_git_repo) \$\[$(tput sgr0)\] "
    if [ -n "${VIRTUAL_ENV}" ]; then
        PS1="\[$(tput setaf 256)\]\[$(tput bold)\]($(basename "${VIRTUAL_ENV}"))\[$(tput sgr0)\] ${PS1}"
    fi
    PS1="\n\[$(tput setaf 3)\]$(pwd)\[$(tput setaf 3)\]\n${PS1}"
}
PROMPT_COMMAND=prompt_command
PROMPT_DIRTRIM=3

alias grb='git fetch && git rebase origin/master'
alias gst='git status'
alias fab="venvexec.sh ./ fab"

BOWERBIN="$(which bower 2>/dev/null)"
bower() {
(
    olddir="$(pwd)"
    while [ ! -f bower.json ]; do
        [ "$(pwd)" = '/' ] && break
        cd ..
    done
    if [ -f bower.json ]; then
        if [ "${olddir}" != "$(pwd)" ]; then
            echo "$(c white bold)>>> $(pwd)$(c reset)" >&2
        fi
        "${BOWERBIN}" "$@"
    else
        echo "No bower.json found" >&2
        return 1
    fi
)
}

GRUNTBIN="$(which grunt 2>/dev/null)"
grunt() {
(
    olddir="$(pwd)"
    while [ ! -f Gruntfile.coffee ]; do
        [ "$(pwd)" = '/' ] && break
        cd ..
    done
    if [ -f Gruntfile.coffee ]; then
        if [ "${olddir}" != "$(pwd)" ]; then
            echo "$(c white bold)>>> $(pwd)$(c reset)" >&2
        fi
        venvexec.sh ./ "${GRUNTBIN}" "$@"
    else
        echo "No Gruntfile.coffee found" >&2
        return 1
    fi
)
}

[ -r /usr/bin/virtualenvwrapper.sh ] && . /usr/bin/virtualenvwrapper.sh

#   Change Prompt
#   ------------------------------------------------------------
    # Custom bash prompt via kirsle.net/wizards/ps1.html
#PS1='\w\n\u@\h\\$
