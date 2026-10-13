pushd ~/git/dotfiles > /dev/null
    git fetch origin main >/dev/null 2>&1
    read ahead behind < <(git rev-list --left-right --count HEAD...origin/main)
    if [ "$behind" -gt 0 ]; then
        echo "❌ dotfiles: You're $behind behind, rebase!"
    fi

    if [ "$ahead" -gt 0 ]; then
        echo "❌ dotfiles: You're $ahead ahead, push!"
    fi

    git diff --quiet && git diff --cached --quiet
    nochanges=$?
    if [ $nochanges -ne "0" ]; then
        echo "❌ dotfiles: Commit your changes!"
    else
        git pull > /dev/null
        if [ "$(git rev-parse main)" != "$(git rev-parse origin/main)" ]; then
            echo "❌ dotfiles not up to date"
        fi
    fi
popd > /dev/null
