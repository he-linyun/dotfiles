# Set Zsh options
setopt correct             # Auto correct minor command typos
setopt hist_ignore_dups    # Ignore duplicate commands in history
setopt no_beep             # Disable the terminal bell

# Customize prompt appearance
PROMPT='%F{magenta}%n%f@%F{cyan}%m%f:%F{green}%~%f %# '

# history settings
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# my aliases
[ -f "$HOME/.dotfiles/.aliases" ] && source "$HOME/.dotfiles/.aliases"

# Load plugins
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh #Ensure this is sourced after zsh-autosuggestions to avoid conflicts

# keybindings for zsh-autosuggestions
bindkey '^I' autosuggest-accept # Accept autosuggestion with Tab
bindkey '\e[Z' expand-or-complete # Show completion menu with Shift+Tab

# special keybindings, only work for ghostty
# other terminal emulators may not recognize these keybindings
bindkey '\e[3;2~' delete-char # Map shift+delete to forward delete
#bindkey '\e[3;9~' delete-char # Map cmd+backspace to forward delete