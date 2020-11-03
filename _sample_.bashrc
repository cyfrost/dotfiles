# .bashrc
# Change directories in terminal without having to use cd everytime.
shopt -s autocd

export TOKEN="<YOUR_GITHUB_OAUTH_TOKEN_HERE>"
export REPOSDIR="$HOME/repos"
export REPOS_DIR="$REPOSDIR"

# message colors.
info_text_blue=$(tput setaf 7);
normal_text=$(tput sgr0);
error_text=$(tput setaf 1);
status_text_yellow=$(tput setaf 3);

function print(){
   printf "\n${status_text_yellow}$1${normal_text}\n\n"
}

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

if [ "$SHELL" == "/data/data/com.termux/files/usr/bin/bash" ]; then
	export IS_TERMUX="true"
fi

export SRC_EDITOR="vi"

# run java code. usage: jrun <filename.java>
function jrun(){
output_filename="${1%.*}"
javac "$1" && echo "Running $output_filename.class..." && java "$output_filename" && exit 0
}

function ipl(){
	ETH_INTF_NAME=$(ls /sys/class/net | grep enp)
	LOCAL_IP=$(ip -o -4 addr list $ETH_INTF_NAME | awk '{print $4}' | cut -d/ -f1)
	print "Local IP: $LOCAL_IP"
}

# run c code. usage: crun <filename.c>
function crun(){
output_filename="${1%.*}"
gcc "$1" -o "$output_filename" && ./$output_filename
}

# revert commits via git. usage: revert <no_of_commits_to_revert>
function revert(){
NUM_COMMITS_TO_REVERT="$1" && git revert --no-commit HEAD~$NUM_COMMITS_TO_REVERT..
}

function up_nvm(){

	print "Updating NVM..."
    NVM_CURRENT_VER="$(nvm --version 2>/dev/null)"
    NVM_LATEST_VER="$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | jq -r ".name")"
    NVM_COMPARE="${NVM_LATEST_VER:1}"

    if [ "$NVM_CURRENT_VER" == "$NVM_COMPARE" ]; then
        print "NVM is up-to-date!"
    else
        print "Updating NVM from v$NVM_CURRENT_VER to v$NVM_COMPARE"
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_LATEST_VER/install.sh | bash
        source "$HOME/.bashrc"
        print "Finished!"
    fi

}

function up_node(){
    nvm install node --reinstall-packages-from=node
    nvm install-latest-npm
    nvm alias default node
}

function up_youtube-dl(){
	print "Updating youtube-dl..."
    YTDL_CURRENT_VER="$(youtube-dl --version 2>/dev/null)"
    YTDL_LATEST_VER="$(curl -sL "https://api.github.com/repos/ytdl-org/youtube-dl/releases/latest" | jq -r '.tag_name')"

    if [ "$YTDL_CURRENT_VER" == "$YTDL_LATEST_VER" ]; then
        print "youtube-dl is up-to-date."
    else
        print "Updating from v$YTDL_CURRENT_VER to v$YTDL_LATEST_VER..."
        tag_name="$(curl -sL "https://api.github.com/repos/ytdl-org/youtube-dl/releases/latest" | jq -r '.tag_name')" && filename="$HOME/youtube-dl" && rm -rf $filename; wget --quiet https://github.com/ytdl-org/youtube-dl/releases/download/$tag_name/youtube-dl -O "$filename"; sudo cp -f "$filename" "/usr/bin/youtube-dl" && sleep 1 && rm -rf $filename && print "Done";
    fi
}

function upload_to_github(){
    REPO_NAME="$1"
    SOURCE_FILENAME="$2"

    DEST_FILENAME="${SOURCE_FILENAME##*/}"
    print "Uploading file \"$DEST_FILENAME\" to GitHub repo \"$REPO_NAME\""
    cur_dir=$(pwd)
    repo_dir="$HOME/repos"
    mkdir -p $repo_dir && \
    cd $repo_dir && \
    print "Cloning repo..."
    git clone --quiet https://<YOUR_GITHUB_USERNAME_HERE>:$TOKEN@github.com/<YOUR_GITHUB_USERNAME_HERE>/$REPO_NAME;
    cd $REPO_NAME && \
    print "Updating repo..."
    git pull;
    print "Committing new changes..."
    cp -f "$SOURCE_FILENAME" . && \
    git add "$DEST_FILENAME" && \
    git status && \
    git commit -m "Update $DEST_FILENAME via Wrapper script" || { print "Everything up-to-date\n\nDone"; cd "$cur_dir"; return; }
    git push && \
    cd "$cur_dir"
    print "Done"
}

function update_all_stuff(){
    up_youtube-dl
    print "Updating flatpaks..."
    flatpak update -y
    up_nvm
    print "Updating Node and NPM..."
    up_node
    print "Updating all global NPM packages..."
    npm update -g
    print "Updating Fedora packages..."
    sudo dnf upgrade -y --best --allowerasing --refresh
    print "All update candidates have run successfully!"
}

#new
alias clip='xclip -sel clip'

alias dark_theme='gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark" && gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark" && gsettings set org.gnome.desktop.interface cursor-theme "Breeze_Snow" && gsettings set org.gnome.shell.extensions.user-theme name ""'

alias light_theme='gsettings set org.gnome.desktop.interface gtk-theme "Adwaita" && gsettings set org.gnome.desktop.interface icon-theme "Papirus-Light" && gsettings set org.gnome.desktop.interface cursor-theme "breeze_cursors" && gsettings set org.gnome.shell.extensions.user-theme name ""'

# fedora specific
alias i='sudo dnf info $1'
alias u="update_all_stuff"
alias distrosync='sudo dnf distro-sync'
alias ins='sudo dnf install -y '
alias rpminfo='rpm -qip '

# git
alias push="git status && git add . && git status && git commit -m update && git push "
alias gs='git status '
alias ga='git add '
alias gaa='git add . '
alias commit='git commit '
alias gc='git clone '
alias gco='git checkout '
alias gp='git pull '

# devel
alias p='python '
alias py='python3 '
alias st='subl '
alias nstart='npm start '
alias ni='npm i '
alias nis='npm i --save '
alias npmli='npm list -g --depth=0'
alias nid='npm i --save-dev '
alias nig='npm i -g '
alias up_deps='npm i -g npm && npm i -g npm-check-updates && ncu && ncu -u && npm install && echo -en "\nDeps updated successfully! \n\n"'
alias xampp_gui='cd /opt/lampp && sudo ./manager-linux-x64.run && cd ~'
alias xampp_start='cd /opt/lampp && sudo ./xampp start && cd ~'
alias xampp_stop='cd /opt/lampp && sudo ./xampp stop && cd ~'

# updating stuff
alias rup='GITHUB_OAUTH_TOK="$TOKEN" && filename="./pull_repos.sh" && rm -f $filename; curl -s https://raw.githubusercontent.com/cyfrost/dotfiles/master/pull_repos.sh >> "$filename"; chmod +x $filename && $filename $GITHUB_OAUTH_TOK && rm -f $filename'
alias up_themes='curl -s https://raw.githubusercontent.com/tliron/install-gnome-themes/master/install-requirements-fedora | bash - && THEMES_PATH="/home/$USER/repos/install-gnome-themes" && mkdir -p "$THEMES_PATH"; git clone https://github.com/tliron/install-gnome-themes "$THEMES_PATH"; git -C "$THEMES_PATH" pull && "$THEMES_PATH/install-gnome-themes"'
alias push_ebrc='print "Pushing current .bashrc to Git master" && upload_to_github <SOME_GITHUB_REPO_NAME> "$HOME/.bashrc" && print "Pushed successfully!"'
alias pull_ebrc='cp -f "$HOME/.bashrc" "$HOME/bashrc_old_$(date +"%Y-%m-%d_%H-%M-%S")"; curl -H "Authorization: token $TOKEN" -H "Accept: application/vnd.github.v3.raw" -L -s https://api.github.com/repos/cyfrost/<SOME_GITHUB_REPO_NAME>/contents/.bashrc > "$HOME/.bashrc"; source "$HOME/.bashrc"; printf "\n\nFinished! \n\n\n"'

# nav
alias ~='cd ~'
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias n='nautilus .'
alias start='nautilus .'
alias repos='cd ~/repos '

# proc
alias sigterm='sudo pkill -SIGTERM '
alias sigkill='sudo pkill -SIGKILL '
alias stop_pid='sudo kill -SIGTERM '
alias kill_pid='sudo kill -SIGKILL '

# misc
alias d='kdiff3 '
alias r='source ~/.bashrc'
alias c='tput reset'
alias e='exit'
alias s='sudo updatedb && locate '
alias rmd='rm -rf '
alias rm='rm -i '
alias h='history'
alias j='jobs -l'
alias ping='ping -c 5 google.com '
alias mem='free -mlht '
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
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'
alias ports='sudo netstat -tulanp'
alias wget='wget -c '
alias untar='tar -zxvf '
alias genpass="openssl rand -base64 20"
alias sha='shasum -a 256 '
alias ipe='print "External IP: $(curl -s ipinfo.io/ip)"'
alias esshc='vim ~/.ssh/config '
alias ebrc='subl ~/.bashrc '
alias ealiasconfig='vim ~/.bashrc '
alias f='fuck'

# tmux
alias tn='tmux new-session -s '
alias ta='tmux attach -t '
alias tl='tmux ls '
alias tk='tmux kill-session -s '

# backup dotfiles and config to github aliases
alias upload_favapps_config='file="$HOME/launcher_favapps.config" && gsettings get org.gnome.shell favorite-apps > $file && upload_to_github dotfiles $file && rm -f $file'
alias upload_tilix_config='file="$HOME/tilix_conf.dconf" && dconf dump /com/gexperts/Tilix/ > $file && upload_to_github dotfiles $file && rm -f $file'
alias upload_guake_config='file1="$HOME/apps-guake.xml" && file2="$HOME/schemas-apps-guake.xml" && gconftool-2 --dump /apps/guake > $file1 && upload_to_github dotfiles $file1 && gconftool-2 --dump /schemas/apps/guake > $file2 && upload_to_github dotfiles $file2 && rm -f $file1 $file2'
alias upload_dash_to_panel_config='file="$HOME/dash_to_panel_config" && dconf dump /org/gnome/shell/extensions/dash-to-panel/ > $file && upload_to_github dotfiles $file && rm -f $file'

# termux aliases
alias trup='token="$TOKEN" && curl -s "https://raw.githubusercontent.com/cyfrost/dotfiles/master/pull_repos.sh" | sed -e "s|^REPOS_DIR=.*|REPOS_DIR="/sdcard/repos/"|g" | bash -s $token && printf "\n\nDone! \n\n\n"'
alias tu="termux-setup-storage; apt update -y; apt upgrade -y; pkg update -y; pkg upgrade -y;"
alias tins="pkg install -y "
alias upload_history='upload_to_github <SOME_GITHUB_REPO_NAME> "$HOME/.bash_history"'

# open sources in sublime text
alias set_editor_code='export SRC_EDITOR=code'
alias set_editor_sublime='export SRC_EDITOR=subl'
alias set_editor_vim='export SRC_EDITOR=vim'

export HISTFILESIZE=
export HISTSIZE=

if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

export GOPATH=$HOME/go

if [ "$IS_TERMUX" != "true" ]; then
	export ETH_INTF_NAME=$(ls /sys/class/net | grep enp)
	export LOCAL_IP=$(ip -o -4 addr list $ETH_INTF_NAME | awk '{print $4}' | cut -d/ -f1)
    # print "Uptime: $(uptime -p)."
else
	alias u='tu';
	alias rup='trup';
    alias ins='tins '
    # print "Uptime: $(uptime)"
fi

export PATH="$HOME/.config/composer/vendor/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="/home/cyrus/.deno/bin:$PATH"
eval $(thefuck --alias)
