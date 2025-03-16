clangBase="/opt/homebrew/Cellar/llvm"
if ! [ -d "$clangBase" ]; then
    echo "\e[31mNo Clang version is not installed\e[0m"
else
    clangVersion="19.1.7_1"
    clangDir="$clangBase/$clangVersion/bin"
    if ! [ -f "$clangDir/clang" ]; then
        usedClangVersion=""
        echo "\e[31mClang $clangVersion not found, update .zshrc\e[0m"
        echo "Existing versions in $clangBase:"
        for dir in $clangBase/*/; do # list directories in the form "/tmp/dirname/"
            dir=${dir%*/}            # remove the trailing "/"
            echo "  - ${dir##*/}"    # print everything after the final "/"
            usedClangVersion=${dir##*/}
        done
        echo "\e[33mUsing $usedClangVersion\e[0m"
        clangDir="$clangBase/$usedClangVersion/bin"
    fi
fi
PATH="$clangDir${PATH:+:${PATH}}"
export PATH
export CC=clang
export CXX=clang++
