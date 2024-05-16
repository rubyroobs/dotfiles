#!/bin/zsh
echo "start asdf install/update"
. $HOME/.asdf/asdf.sh
asdf plugin add ruby
asdf install ruby latest
asdf global ruby latest
asdf plugin add nodejs
asdf install nodejs latest
asdf global nodejs latest
asdf plugin add golang
asdf install golang latest
asdf global golang latest
echo "end asdf install/update"