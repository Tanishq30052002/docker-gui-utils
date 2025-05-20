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

################################## PC ######################################
export IP_PC_WIFI=$(ip addr show wlp4s0 | grep 'inet ' | awk '{print $2}' | cut -d'/' -f1)
# export IP_PC_LAN=$(ip addr show enp7s0 | grep 'inet ' | awk '{print $2}' | cut -d'/' -f1)

export IP_PC=$IP_PC_WIFI
# export IP_PC=$IP_PC_LAN
if [[ -z "${IP_PC}" ]]; then
    IP_PC="localhost"
fi

export ROS_MASTER_URI="http://${IP_PC}:11311"
export ROS_HOSTNAME="${IP_PC}"

