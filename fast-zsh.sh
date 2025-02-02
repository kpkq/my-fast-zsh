#!/bin/bash

input=1
ZSH_CUSTOM=$HOME/.oh-my-zsh/custom

start() {
    echo "Select version"
    echo "  1) Server"
    echo "  2) User"
    echo "  3) Quit"

    read n
    case $n in
    1)
        echo "Default server"
        input=1
        return
        ;;
    2)
        echo "Default user"
        input=2
        return
        ;;
    3)
        echo "Bye."
        exit
        ;;
    *) echo "Invalid option" ;;
    esac

}

start
pkg0='zsh'
pkg1='git'
pkg2='curl'

if dpkg -s $pkg0 >/dev/null 2>&1 && dpkg -s $pkg1 >/dev/null 2>&1 &&  dpkg -s $pkg2 >/dev/null 2>&1; then
    echo -e "git & zsh & curl are already installed"
else
    if sudo apt install -y zsh git curl || sudo pacman -S zsh git curl || sudo dnf install -y zsh git curl || sudo yum install -y zsh git curl || sudo brew install git zsh curl || pkg install git zsh curl; then
        echo -e "git & zsh & curl Installed"
    else
        echo -e "Please install the following packages first, then try again: zsh git curl \n" && exit
    fi
fi

if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "Directory $HOME/.oh-my-zsh exists."
else
    echo "Installing Oh My ZSH"
    yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" 
fi

if [ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "autosuggestions already downladed"
else
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "syntax-highlighting already downladed"
else
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" &>/dev/null
fi

for dir in \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions" \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"; do
    if ! [ -d "$dir" ]; then
        echo "Something weird happened. No dirs with plugins were generated"
        exit
    else
        if [ "$input" = 1 ]; then
            sed -i '/ZSH_THEME=/c\ZSH_THEME="candy"' $HOME/.zshrc
            sed -i '/plugins=(/c\plugins=(git zsh-autosuggestions zsh-syntax-highlighting)' $HOME/.zshrc
        else
            sed -i '/ZSH_THEME=/c\ZSH_THEME="candy"' $HOME/.zshrc
            sed -i '/plugins=(/c\plugins=(git zsh-autosuggestions zsh-syntax-highlighting)' $HOME/.zshrc
        fi
    fi
done
chsh -s $(which zsh)

sleep 5

zsh

exit
