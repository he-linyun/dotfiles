
## macOS install

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
brew install git
git clone https://github.com/he-linyun/dotfiles.git ~/.dotfiles
/bin/bash "$HOME/.dotfiles/bootstrap.sh"
```