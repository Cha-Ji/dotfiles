# dotfiles

- symbolic link
```
ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
```

- vim vundle
```
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

- onedark theme (FIXME)
```
mkdir ~/.vim/colors/
ln -s ~/.dotfiles/colors/onedark.vim ~/.vim/colors/

mkdir ~/.vim/autoload/
ln -s ~/.dotfiles/autoload/onedark.vim ~/.vim/autoload/
```
