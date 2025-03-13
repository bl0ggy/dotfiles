## Works on zsh
## https://superuser.com/questions/735660/whats-the-zsh-equivalent-of-bashs-prompt-command
## for bash: https://stackoverflow.com/questions/16715103/bash-prompt-with-the-last-exit-code

# 'ZSH_VERSION' only defined in Zsh
if ! [ ${ZSH_VERSION} ] ; then
    echo "Not a zsh shell"
    exit 1
fi
# [ ${BASH_VERSION} ] && PROMPT_COMMAND=myprompt

# 'precmd' is a special function name known to Zsh
prmptcmd() { myprompt }
precmd_functions=(prmptcmd)

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

myprompt() {
    local exitCode="$?"                # This needs to be first
    PS1=""
    ColorReset=$'%{\033[0m%}'
    Red=$'%{\033[0;38;5;1m%}'
    Green=$'%{\033[0;38;5;2m%}'
    Blue=$'%{\033[0;38;5;6m%}'

    # Add exit code if error
    if [ $exitCode != 0 ]; then
        PS1+="${Red}"        # Add red if exit code non 0
        PS1+="$exitCode "    # and print exit code value
    else
        PS1+="${Green}"      # Otherwise add green color
    fi

    # Add username@machine and current directory
    # "\033[1;3;38;5;1mTest" # 1: bold, 3: italic, 38;5: set foreground
    PS1+="%n@%m $Blue%1~"

    # Add git branch if exists
    branch=$(parse_git_branch)
    if [ -z $branch ] ; then
        PS1+=""
    else
        PS1+=" ($branch)"
    fi

    # Add privileges character
    PS1+=" ${ColorReset}%# "
}
