########################### ZSH SETTINGS #######################################
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="af-magic"

plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
  you-should-use
  zsh-history-substring-search
  nmap
)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff048a,standout"

source $ZSH/oh-my-zsh.sh

################################ ACCESSORY #####################################
export color_prompt=yes
alias reload="source ~/.zshrc"
alias upgrade="sudo apt update && sudo apt upgrade -y && sudo snap refresh && sudo apt autoremove -y && sudo apt autoclean"
