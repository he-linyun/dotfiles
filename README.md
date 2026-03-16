## macOS

```sh
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

brew install git
git clone https://github.com/he-linyun/dotfiles.git $HOME/.dotfiles
/bin/bash "$HOME/.dotfiles/mac_bootstrap.sh"
```

## Windows

```powershell
winget install -e --id Microsoft.AppInstaller
winget upgrade Microsoft.AppInstaller

winget install --id Git.Git -e -s winget --accept-source-agreements --accept-package-agreements
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

git clone https://github.com/he-linyun/dotfiles.git $HOME/.dotfiles
powershell -ExecutionPolicy Bypass -File "$HOME\.dotfiles\win_bootstrap.ps1"
```