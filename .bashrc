# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

#  MY NEW BASHRC

# User specific environment
PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
function jrun(){
output_filename="${1%.*}"
javac "$1" && echo "Running $output_filename.class..." && java "$output_filename" && exit 0
}

function crun(){
output_filename="${1%.*}"
gcc "$1" -o "$output_filename" && ./$output_filename
}

function revert(){
NUM_COMMITS_TO_REVERT="$1" && git revert --no-commit HEAD~$NUM_COMMITS_TO_REVERT..
}

alias ins='sudo dnf install -y $1'
alias up='sudo dnf upgrade --best --allowerasing --refresh && sudo dnf autoremove'
alias u='sudo dnf update -y && sudo dnf upgrade -y && sudo dnf autoremove -y'
alias distrosync='sudo dnf distro-sync'
alias ins='sudo dnf install -y '
alias c='tput reset'
alias e='exit'
alias n='nautilus .'
alias start='nautilus .'
alias s='sudo updatedb && locate '
alias xampp_gui='cd /opt/lampp && sudo ./manager-linux-x64.run && cd ~'
alias xampp_start='cd /opt/lampp && sudo ./xampp start && cd ~'
alias xampp_stop='cd /opt/lampp && sudo ./xampp stop && cd ~'
alias sigterm='sudo pkill -SIGTERM '
alias rmd='rm -rfv '
alias sigkill='sudo pkill -SIGKILL '
alias stop_pid='sudo kill -SIGTERM '
alias kill_pid='sudo kill -SIGKILL '
alias up_themes='curl -s https://raw.githubusercontent.com/tliron/install-gnome-themes/master/install-requirements-fedora | bash - && THEMES_PATH="/home/$USER/repos/install-gnome-themes" && mkdir -p "$THEMES_PATH"; git clone https://github.com/tliron/install-gnome-themes "$THEMES_PATH"; git -C "$THEMES_PATH" pull && "$THEMES_PATH/install-gnome-themes"'
alias ~='cd ~'
alias ins_atom="sudo dnf install -y $(curl -sL "https://api.github.com/repos/atom/atom/releases/latest" | grep "https.*atom.x86_64.rpm" | cut -d '"' -f 4);"
alias up_npm='sudo npm outdated -g && sudo npm update -g'
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias h='history'
alias j='jobs -l'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'
alias ports='sudo netstat -tulanp'
alias wget='wget -c '
alias untar='tar -zxvf '
alias genpass="openssl rand -base64 20"
alias sha='shasum -a 256 '
alias ipe='curl ipinfo.io/ip '
alias esshconfig='vim ~/.ssh/config '
alias ealiasconfig='vim ~/.bashrc '
alias tn='tmux new-session -s'
alias ta='tmux attach -t'
alias tl='tmux ls'
alias tk='tmux kill-session -s'
alias ipl='ip addr show enp2s0 | grep --word-regexp inet | awk "{print $2}"'
alias ni='npm i '
alias nis='npm i --save '
alias nid='npm i --save-dev '
alias nig='sudo npm i -g '
alias push="git status && git add . && git status && git commit -m update && git push "
alias nls='npm list -g --depth 0 '
alias gs='git status '
alias ga='git add '
alias gaa='git add . '
alias commit='git commit '
alias gc='git clone '
alias gco='git checkout '
alias gp='git pull '
alias ping='ping -c 5 google.com '
alias nstart='npm start '
alias mem='free -mlht '
alias st='subl '
alias lock='dbus-send --type=method_call --dest=org.gnome.ScreenSaver /org/gnome/ScreenSaver org.gnome.ScreenSaver.Lock'
alias l='ls -AltchF --color=auto --group-directories-first --classify --time-style=+"%Y-%m-%d %H:%M" '
alias g='grep -i --color=auto '
alias v='vim '
alias fs='df -hlT --exclude-type=tmpfs --exclude-type=devtmpfs '
alias cls='clear '
alias clr='clear '
alias chrome='/usr/bin/google-chrome '
alias sv='sudo vim '
alias ff='firefox '
alias repos='cd ~/repos '
alias r='source ~/.bashrc'
alias p='python '
alias py='python3 '
alias d='kdiff3 '
#alias rup='curDir=`pwd` && HIGHLIGHT="\e[01;34m" && NORMAL="\e[00m" && REPOS_PATH="$HOME/repos" && cd $REPOS_PATH && for d in `find . -name .git -type d`; do   cd $d/.. > /dev/null;   echo -e "\n${HIGHLIGHT}Updating `pwd`$NORMAL";   git pull;   cd - > /dev/null; done;     printf "\n" && cd $curDir'
alias rup='GITHUB_OAUTH_TOK="lmao" && filename="./pull_repos.sh" && rm -f $filename; curl -s https://raw.githubusercontent.com/cyfrost/dotfiles/master/pull_repos.sh >> "$filename"; chmod +x $filename && $filename $GITHUB_OAUTH_TOK'
alias i='sudo dnf info $1'

export HISTFILESIZE=
export HISTSIZE=
