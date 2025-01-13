eval "$(/opt/homebrew/bin/brew shellenv)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source ~/Dropbox/Workspace/johahae/OVH_server/.custom_zshrc

# bun completions
[ -s "/Users/jessysimeon/.bun/_bun" ] && source "/Users/jessysimeon/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/jessysimeon/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end


# Allow Home key to work in zsh
bindkey '\e[H'  beginning-of-line
bindkey '\eOH'  beginning-of-line
# Allow End key to work in zsh
bindkey '\e[F'  end-of-line
bindkey '\eOF'  end-of-line

alias la="ls -la"

updatekitty () {
     curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
}
# Set tab title (works on Kitty)
title() {
    echo -e -n "\033]$1\007"
    TITLE=$1
}
reset() {
    command reset # This reset the title
    title $TITLE
}

clangBase="/opt/homebrew/Cellar/llvm"
if ! [ -d "$clangBase" ]; then
    echo "\e[31mNo Clang version is not installed\e[0m"
else
    clangVersion="19.1.6"
    clangDir="$clangBase/$clangVersion/bin"
    if ! [ -f "$clangDir/clang" ]; then
        usedClangVersion=""
        echo "\e[31mClang $clangVersion not found, update .zshrc\e[0m"
        echo "Existing versions in $clangBase:"
        for dir in $clangBase/*/     # list directories in the form "/tmp/dirname/"
        do
            dir=${dir%*/}      # remove the trailing "/"
            echo "  - ${dir##*/}"    # print everything after the final "/"
            usedClangVersion=${dir##*/}
        done
        echo "\e[33mUsing $usedClangVersion\e[0m"
        clangDir="$clangBase/$usedClangVersion/bin"
    fi
fi
PATH="$clangDir${PATH:+:${PATH}}"; export PATH;
export CC=clang
export CXX=clang++

# Deno
. "/Users/jessysimeon/.deno/env"
