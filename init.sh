#!/usr/bin/env bash
# wget https://raw.githubusercontent.com/haitian-jiang/dotfiles/refs/heads/main/init.sh -O - | bash

# zsh
sudo apt update
# sudo apt install -y zsh wget exa libtbb-dev
sudo chsh -s $(which zsh) $(whoami)
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

mkdir -p ~/repos
if [ ! -d ~/repos/dotfiles ]; then
    git clone https://github.com/haitian-jiang/dotfiles.git ~/repos/dotfiles
fi
ln -s ~/repos/dotfiles/jht.zsh-theme ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/jht.zsh-theme

# link dotfiles
cp ~/repos/dotfiles/zshrc ~/.zshrc
ln -s ~/repos/dotfiles/vimrc ~/.vimrc
ln -s ~/repos/dotfiles/tmux.conf ~/.tmux.conf
ln -s ~/repos/dotfiles/gitconfig ~/.gitconfig
ln -s ~/repos/dotfiles/condarc ~/.condarc
mkdir -p ~/.config/htop
ln -s htoprc ~/.config/htop/htoprc

# install conda
if command -v conda &> /dev/null; then
    echo "Conda is installed and available in PATH."
    # You can now run conda commands
    conda --version
else
    sudo mkdir -p /opt/miniconda3
    sudo chown $(whoami):$(whoami) /opt/miniconda3
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /opt/miniconda3/miniconda.sh
    bash /opt/miniconda3/miniconda.sh -b -u -p /opt/miniconda3
    rm -rf /opt/miniconda3/miniconda.sh
    /opt/miniconda3/bin/conda init zsh
fi

# install tmux and plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux source ~/.tmux.conf

sudo timedatectl set-timezone America/New_York
