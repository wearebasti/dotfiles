# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory nomatch
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/Users/sebastian/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Help files:
unalias run-help
autoload run-help
HELPDIR=/usr/local/share/zsh/help

# Make history awesome
setopt INC_APPEND_HISTORY

# Use zsh-completions
fpath=(/usr/local/share/zsh-completions $fpath)

# Exports
source ~/.exports
bindkey -e  # explicitly set it here as export EDITOR=vim changes it appearently

# source ~/.zkbd/$TERM-${${DISPLAY:t}:-$VENDOR-$OSTYPE}
# autoload zkbd
source /Users/seitzs/.zkbd/xterm-256color-apple-darwin15.0
[[ -n ${key[PageUp]} ]] && bindkey "${key[PageUp]}" beginning-of-line
[[ -n ${key[PageDown]} ]] && bindkey "${key[PageDown]}" end-of-line
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
# bindkey -m

# Aliases
source ~/.aliases

umask 022

# plugins
# source ~/.zsh_plugins/gitfast-zsh-plugin/git-prompt.sh

autoload -Uz vcs_info

# git checker:
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' check-for-changes true
zstyle ':vcs_info:git*' get-revision true
zstyle ':vcs_info:git*' formats "[%b%m]%c%u" # branch % remote tracking
# zstyle ':vcs_info:*+*:*' debug true
zstyle ':vcs_info:git*+set-message:*' hooks git-st git-untracked

+vi-git-untracked(){
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep '??' &> /dev/null ; then
        # This will show the marker if there are any untracked files in repo.
        # If instead you want to show the marker only if there are untracked
        # files in $PWD, use:
        #[[ -n $(git ls-files --others --exclude-standard) ]] ; then
        hook_com[staged]+=' ?'
    fi
}


### git: Show +N/-N when your local branch is ahead-of or behind remote HEAD.
# Make sure you have added misc to your 'formats':  %m
function +vi-git-st() {
    local ahead behind
    local -a gitstatus

    # for git prior to 1.7
    # ahead=$(git rev-list origin/${hook_com[branch]}..HEAD | wc -l)
    
    ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
    (( $ahead )) && gitstatus+=( " ⬆${ahead//[^[:alnum:]]/}" )

    # for git prior to 1.7
    # behind=$(git rev-list HEAD..origin/${hook_com[branch]} | wc -l)
    behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)
    (( $behind )) && gitstatus+=( " ⬇${behind//[^[:alnum:]]/}" )

    hook_com[misc]+=${(j::)gitstatus}
}

nl='
'

autoload -U colors && colors

precmd() {
    # As always first run the system so everything is setup correctly.
    vcs_info
    # And then just set PS1, RPS1 and whatever you want to. 
    # See "man zshmisc" for details on how to
    # make this less readable. :-)

#   # are we in a virtual-env? if: show name
    if [ -n "$VIRTUAL_ENV" ]; then
        venv_name='('$(basename $VIRTUAL_ENV)') '
    else
        venv_name=''
    fi

    if [ -z "${vcs_info_msg_0_}" ]; then
        # Oh hey, nothing from vcs_info, so we got more space.
        # Let's print a longer part of $PWD...
        PS1="%{$reset_color%}%{$fg[yellow]%}%~%{$reset_color%}${nl}%{$fg_bold[blue]%}${venv_name}➤➤➤ %{$reset_color%} "
        unset RPS1
    else
        # vcs_info found something

        # read stash count
        stash_count=$(git stash list | wc -l)
        if [ "$stash_count" -gt "0" ]; then
            stash_count='(+'"${stash_count//[^[:alnum:]]/}"')'
        else
            stash_count=""
        fi

        # create Prompt Message w/ detailted git info
        if git diff --ignore-submodules=dirty --exit-code --quiet 2>/dev/null >&2; then
            if git diff --ignore-submodules=dirty --exit-code --cached --quiet 2>/dev/null >&2; then
                repo="%{$reset_color%}%{$fg[green]%}${stash_count}${vcs_info_msg_0_}%{$reset_color%}"
            else
                repo="%{$reset_color%}%{$fg[cyan]%}${stash_count}${vcs_info_msg_0_}%{$reset_color%}"
            fi
        else
            repo="%{$reset_color%}%{$fg[red]%}${stash_count}${vcs_info_msg_0_}%{$reset_color%}"
        fi

        PS1="%{$reset_color%}%{$fg[yellow]%}%~%{$reset_color%}${nl}%{$fg_bold[blue]%}${venv_name}➤➤➤ %{$reset_color%} "
        RPS1=${repo}
    fi
}
