alias la="ls -la"

updatekitty() {
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

# Allow Home key to work in zsh
bindkey '\e[H' beginning-of-line
bindkey '\eOH' beginning-of-line
# Allow End key to work in zsh
bindkey '\e[F' end-of-line
bindkey '\eOF' end-of-line
# Allow
bindkey "\e[1;5A" beginning-of-line
bindkey "\e[1;5B" end-of-line
bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word
