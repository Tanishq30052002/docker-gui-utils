FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
# Replace security repo with archive mirror
RUN sed -i 's|http://security.ubuntu.com/ubuntu|http://archive.ubuntu.com/ubuntu|g' /etc/apt/sources.list

RUN apt-get update && apt-get upgrade && \
    apt-get install -y \
    sudo \
    adduser \
    wget

RUN wget https://raw.githubusercontent.com/Tanishq30052002/docker-gui-utils/main/add_user.sh -O /usr/local/bin/add_user.sh && \
    chmod +x /usr/local/bin/add_user.sh

# Run the add_user.sh script to add user non-interactively
RUN /usr/local/bin/add_user.sh -r --no_password_recommend user

# Set default user to 'user' for when container runs
USER user
WORKDIR /home/user

# Now run package installs as 'user' with sudo
RUN sudo apt-get update && sudo apt-get update && \
    sudo apt-get install -y \
    curl git zsh \
    tmux htop nano

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
RUN git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN git clone https://github.com/MichaelAquilina/zsh-you-should-use \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/you-should-use
RUN git clone https://github.com/zsh-users/zsh-history-substring-search \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
RUN wget https://raw.githubusercontent.com/Tanishq30052002/docker-gui-utils/refs/heads/main/.zshrc -O ~/.zshrc

RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
RUN wget https://raw.githubusercontent.com/Tanishq30052002/docker-gui-utils/refs/heads/main/.tmux.conf -O ~/.tmux.conf

# Set default shell
CMD ["zsh"]
