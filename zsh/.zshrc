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

clangBase="/opt/homebrew/Cellar/llvm"
if ! [ -d "$clangBase" ]; then
    echo "\e[31mNo Clang version is not installed\e[0m"
else
    clangVersion="18.1.8"
    clangDir="$clangBase/$clangVersion/bin"
    if ! [ -f "$clangDir/clang" ]; then
        echo "\e[31mClang $clangVersion not found, update .zshrc\e[0m"
        echo "Existing versions in $clangBase:"
        for dir in $clangBase/*/     # list directories in the form "/tmp/dirname/"
        do
            dir=${dir%*/}      # remove the trailing "/"
            echo "  - ${dir##*/}"    # print everything after the final "/"
        done
    fi
    PATH="$clangDir${PATH:+:${PATH}}"; export PATH;
fi
