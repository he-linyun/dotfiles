
## macOS

```sh
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

brew install git
git clone https://github.com/he-linyun/dotfiles.git $HOME/.dotfiles
/bin/bash "$HOME/.dotfiles/bootstrap.sh"
```

## Windows

```powershell
winget install -e --id Microsoft.AppInstaller
winget upgrade Microsoft.AppInstaller

winget install --id Git.Git -e -s winget --accept-source-agreements --accept-package-agreements
git clone https://github.com/he-linyun/dotfiles.git $HOME/.dotfiles
winget import -i "$HOME/.dotfiles/winget-packages.json" --accept-package-agreements --accept-source-agreements
```