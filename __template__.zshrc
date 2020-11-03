# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000000
SAVEHIST=10000000
setopt appendhistory autocd extendedglob
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/$USER/.zshrc'

autoload -Uz compinit promptinit
compinit
promptinit

# End of lines added by compinstall
prompt walters
setopt COMPLETE_ALIASES
zstyle ':completion::complete:*' gain-privileges 1
zstyle ':completion:*' menu select

typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[ShiftTab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"      beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"       end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"    overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}" backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"    delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"        up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"      down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"      backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"     forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"    beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"  end-of-buffer-or-history
[[ -n "${key[ShiftTab]}"  ]] && bindkey -- "${key[ShiftTab]}"  reverse-menu-complete

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search
zshcache_time="$(date +%s%N)"

autoload -Uz add-zsh-hook

rehash_precmd() {
  if [[ -a /var/cache/zsh/pacman ]]; then
    local paccache_time="$(date -r /var/cache/zsh/pacman +%s%N)"
    if (( zshcache_time < paccache_time )); then
      rehash
      zshcache_time="$paccache_time"
    fi
  fi
}

add-zsh-hook -Uz precmd rehash_precmd
source /usr/share/doc/pkgfile/command-not-found.zsh

ZSH=/usr/share/oh-my-zsh/

export DEFAULT_USER="rickastley"
export TERM="xterm-256color"
export ZSH=/usr/share/oh-my-zsh

ZSH_THEME="powerlevel10k/powerlevel10k"
POWERLEVEL9K_MODE="nerdfont-complete"
source $ZSH/themes/powerlevel9k/powerlevel9k.zsh-theme

POWERLEVEL9K_FOLDER_ICON=""
POWERLEVEL9K_HOME_SUB_ICON="$(print_icon "HOME_ICON")"
POWERLEVEL9K_DIR_PATH_SEPARATOR=" $(print_icon "LEFT_SUBSEGMENT_SEPARATOR") "

POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0

POWERLEVEL9K_DIR_OMIT_FIRST_CHARACTER=true

POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND='black'
POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND='178'
POWERLEVEL9K_NVM_BACKGROUND="238"
POWERLEVEL9K_NVM_FOREGROUND="green"
POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND="blue"
POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_FOREGROUND="015"

POWERLEVEL9K_TIME_BACKGROUND='255'
#POWERLEVEL9K_COMMAND_TIME_FOREGROUND='gray'
POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='245'
POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='black'

POWERLEVEL9K_TIME_FORMAT="%D{%H:%M}"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(root_indicator context dir dir_writable vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs command_execution_time time)
POWERLEVEL9K_SHOW_CHANGESET=true

HYPHEN_INSENSITIVE="true"
COMPLETION_WAITING_DOTS="true"
# /!\ do not use with zsh-autosuggestions
plugins=(archlinux asdf bundler docker jsontools vscode web-search k tig gitfast colored-man-pages colorize
command-not-found cp dirhistory autojump sudo zsh-syntax-highlighting zsh-autosuggestions)
 # /!\ zsh-syntax-highlighting and then zsh-autosuggestions must be at the end

source $ZSH/oh-my-zsh.sh

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[cursor]='bold'

ZSH_HIGHLIGHT_STYLES[alias]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=green,bold'

# rule () {
# 	print -Pn '%F{blue}'
# 	local columns=$(tput cols)
# 	for ((i=1; i<=columns; i++)); do
# 	   printf "\u2588"
# 	done
# 	print -P '%f'
# }

# function _my_clear() {
# 	echo
# 	rule
# 	zle clear-screen
# }
# zle -N _my_clear
# bindkey '^l' _my_clear

# Ctrl-O opens zsh at the current location, and on exit, cd into ranger's last location.
ranger-cd() {
	tempfile=$(mktemp)
	ranger --choosedir="$tempfile" "${@:-$(pwd)}" < $TTY
	test -f "$tempfile" &&
	if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
	cd -- "$(cat "$tempfile")"
	fi
	rm -f -- "$tempfile"
	# hacky way of transferring over previous command and updating the screen
	VISUAL=true zle edit-command-line
}
zle -N ranger-cd
bindkey '^o' ranger-cd

# alias print="msg"
# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

ZSH_CACHE_DIR=$HOME/.cache/oh-my-zsh
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir $ZSH_CACHE_DIR
fi

source $ZSH/oh-my-zsh.sh

alias jailbreak_checkra1n='cd $HOME && chmod +x jb.sh && ./jb.sh'

# message colors.
info_text_blue=$(tput setaf 7);
normal_text=$(tput sgr0);
error_text=$(tput setaf 1);
status_text_yellow=$(tput setaf 3);

export TOKEN="__"
export REPOSDIR="$HOME/repos"
export REPOS_DIR="$REPOSDIR"
export SERVER="127.0.0.1"

if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ "$SHELL" = "/data/data/com.termux/files/usr/bin/bash" ]; then
	export IS_TERMUX="true"
fi

function msg(){
    printf "\n${status_text_yellow}$1${normal_text}\n\n"
}

function error(){
    printf "\n${error_text}Error: $1${normal_text}\n"
}

function info(){
    printf "\n${info_text_blue}$1${normal_text}\n"
}

function syncsources_lineage () {
	curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
	cd ~/android/lineage
	repo sync
}

function mkbuild() {
	cd ~/android/lineage && \
	source temp-python/bin/activate && \
	python --version && \
	source build/envsetup.sh && \
	setopt shwordsplit && \
	export LC_ALL=C && \
	breakfast X00TD && \
	export USE_CCACHE=1 && \
	export CCACHE_EXEC=/usr/bin/ccache && \
	ccache -M 20G && \
	export CCACHE_COMPRESS=1 && \
	croot && \
	brunch X00TD
}

function confirm_action() {
    while true; do
        printf "\n${normal_text}";
        read -p "$1" -n 1 yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) printf "\nPlease answer with 'y' or 'n'.";;
        esac
    done
}

function bootstrapper_dialog() {
    DIALOG_RESULT=$(dialog --clear --stdout --backtitle "Cyfrost Arch Linux bootstrapper" --no-shadow "$@" 2>/dev/null)
    reset
}

function maps() {
    osm_url="$1"

    lat=$(echo "$osm_url" | sed -E 's/.*mlat=([^&]+).*/\1/')
    lon=$(echo "$osm_url" | sed -E 's/.*mlon=([^&]+).*/\1/')

    gmaps_link="https://www.google.com/maps/?q=$lat,$lon"
    echo $gmaps_link
    xdg-open "$gmaps_link"
}

# function print(){
#    printf "\n${status_text_yellow}$1${normal_text}\n\n"
# }

function jrun(){
	output_filename="${1%.*}"
	javac "$1" && echo "Running $output_filename.class..." && java "$output_filename" && exit 0
}

function ipl(){
	ETH_INTF_NAME=$(ls /sys/class/net | grep enp)
	LOCAL_IP=$(ip -o -4 addr list $ETH_INTF_NAME | awk '{print $4}' | cut -d/ -f1)
	msg "Local IP: $LOCAL_IP"
}

function open() {
    nohup nautilus -w $1 > /dev/null 2>&1 &
}

function crun(){
	output_filename="${1%.*}"
	gcc "$1" -o "$output_filename" && ./$output_filename
}

function revert(){
	NUM_COMMITS_TO_REVERT="$1" && git revert --no-commit HEAD~$NUM_COMMITS_TO_REVERT..
}

function up_nvm(){
	msg "Updating NVM..."
    NVM_CURRENT_VER="$(nvm --version 2>/dev/null)"
    NVM_LATEST_VER="$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | jq -r ".name")"
    NVM_COMPARE="${NVM_LATEST_VER:1}"

    if [ "$NVM_CURRENT_VER" = "$NVM_COMPARE" ]; then
        msg "NVM is up-to-date!"
    else
        msg "Updating NVM from v$NVM_CURRENT_VER to v$NVM_COMPARE"
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_LATEST_VER/install.sh | zsh
        source "$HOME/.zshrc"
        msg "Finished!"
    fi
}

function up_node(){
	up_nvm
    nvm install node --reinstall-packages-from=node
    nvm install-latest-npm
    nvm alias default node
}

function upload_to_github(){
    REPO_NAME="$1"
    SOURCE_FILENAME="$2"

    DEST_FILENAME="${SOURCE_FILENAME##*/}"
    msg "Uploading file \"$DEST_FILENAME\" to GitHub repo \"$REPO_NAME\""
    cur_dir=$(pwd)
    repo_dir="$HOME/repos"
    mkdir -p $repo_dir && \
    cd $repo_dir && \
    msg "Cloning repo..."
    git clone --quiet https://cyfrost:$TOKEN@github.com/cyfrost/$REPO_NAME;
    cd $REPO_NAME && \
    msg "Updating repo..."
    git pull;
    msg "Committing new changes..."
    cp -f "$SOURCE_FILENAME" . && \
    git add "$DEST_FILENAME" && \
    git status && \
    git commit -m "Update $DEST_FILENAME via Wrapper script" || { msg "Everything up-to-date\n\nDone"; cd "$cur_dir"; return; }
    git push && \
    cd "$cur_dir"
    msg "Done"
}

function tv_work() {
    REMOTE_TVID="teamviewer_id_here" && teamviewer && wid=$(xdotool search --pid `pidof TeamViewer`) && sleep 3 && xdotool windowactivate $wid && xdotool key --window $wid ctrl+a && xdotool key --window $wid BackSpace && xdotool type --window $wid "$REMOTE_TVID"  && xdotool key --window $wid Return
}

function update_all_stuff(){
	print "Updating VSCodium..."
	update_codium
    msg "Updating flatcraps..."
    flatpak update -y
    msg "Updating Node and NPM..."
    up_node
    msg "Updating all global NPM packages..."
    npm update -g
    msg "Updating Fedora packages..."
    sudo dnf upgrade -y --best --allowerasing --refresh
    msg "Finished."
}

if [ "$IS_TERMUX" != "true" ]; then
	export ETH_INTF_NAME=$(ls /sys/class/net | grep enp)
	export LOCAL_IP=$(ip -o -4 addr list $ETH_INTF_NAME | awk '{print $4}' | cut -d/ -f1)
    eval $(thefuck --alias)
    # print "Uptime: $(uptime -p)."
else
	alias u='tu';
	alias rup='trup';
    alias ins='tins '
    alias ebrc='v ~/.bashrc'
    # print "Uptime: $(uptime)"
fi

alias ls='ls --color=auto'
alias i='yay -Si '
alias news='archnews'
alias pacman='archnews_wrap'
alias ins='yay -S --noconfirm --needed --answerdiff=None'
alias inslocal='sudo pacman -U --noconfirm'
alias rmpkg='yay -Rns'
alias u='sudo pacman -Syu; yay -Syu --aur --nocleanmenu --nodiffmenu --noeditmenu --removemake --noconfirm --needed --answerdiff=None; update_all_stuff'
alias uu='yay'
alias router='ssh-keygen -R gatewayiphere > /dev/null && sshpass -p supersecretpasswordhere ssh -oStrictHostKeyChecking=no root@gatewayiphere'
alias connect_phone='adb connect adbhostiphere:5555 && killall scrcpy; scrcpy -m 1024;'
alias dev='tmux new-session -d -s scrcpy > /dev/null 2>&1; tmux send-keys 'connect_phone' C-m; tmux detach -s scrcpy > /dev/null 2>&1;'d
alias initwork='lanosrep &; work &; teamviewer &; sleep 5; tv_work; sleep 2; tv_work'
alias work='google-chrome-stable %U --profile-directory="Profile 3"'
alias lanosrep='google-chrome-stable %U --profile-directory="Profile 2"'
alias hosts='sudo nmap -sL 192.168.1.* | g ".lan"'
alias startwin='virsh restore /var/lib/libvirt/qemu/save/win10.save; virsh start win10; virt-manager --connect qemu:///system --show-domain-console win10'
alias forceshutdownwin='sudo virsh shutdown win10'
alias forcerebootwin='sudo virsh reboot win10'
alias savewin='sudo virsh save win10 /var/lib/libvirt/qemu/save/win10.save'
alias killwin='sudo virsh destroy win10'
alias chutiya_ubuntu='docker run -it ubuntu:latest bash'
alias fedora='docker run -it fedora_new'
alias veracrypt_mount_favorites="cat $HOME/Documents/.volkey | tr -cd '[:alnum:]._-' | clip; veracrypt --auto-mount=favorites && echo cat | clip"
alias unmount_volumes='veracrypt -d; sleep 2; veracrypt -d; sleep 2; veracrypt -d; sleep 2; veracrypt -d'
alias clip='xclip -sel clip'

alias darktheme='gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark" && gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark" && gsettings set org.gnome.desktop.interface cursor-theme "Breeze_Snow" && gsettings set org.gnome.shell.extensions.user-theme name ""'

alias lighttheme='gsettings set org.gnome.desktop.interface gtk-theme "Adwaita" && gsettings set org.gnome.desktop.interface icon-theme "Papirus-Light" && gsettings set org.gnome.desktop.interface cursor-theme "breeze_cursors" && gsettings set org.gnome.shell.extensions.user-theme name ""'

# fedora specific
# alias i='sudo dnf info $1'
# alias u="update_all_stuff"
# alias distrosync='sudo dnf distro-sync'
# alias update_codium='bash <(curl -s https://gist.githubusercontent.com/cyfrost/1f9169eebee8dbed9962d4e3800edf38/raw/install-latest-vscodium-fedora.sh)'
# alias ins='sudo dnf install -y '
# alias rpminfo='rpm -qip '
alias no_chess='sshpass -psupersecretpasswordhere ssh -o StrictHostKeyChecking=no root@openwrt.lan '\''uci del dhcp.@dnsmasq[0].server; uci add_list dhcp.@dnsmasq[0].server=/chess.com/ && uci add_list dhcp.@dnsmasq[0].server=/lichess.org/ && uci add_list dhcp.@dnsmasq[0].server='\''/nomansky.org/'\'' && uci commit dhcp && /etc/init.d/dnsmasq restart'\'''
alias chess='sshpass -psupersecretpasswordhere ssh -o StrictHostKeyChecking=no root@openwrt.lan '\''uci del dhcp.@dnsmasq[0].server && uci commit dhcp && /etc/init.d/dnsmasq restart'\'''

alias clone_vps='scr="/home/$USER/clone_droplet.sh" && chmod +x $scr && . $scr'

# git
alias push="git add .; git commit -m update; git push"
alias gs='git status '
alias ga='git add '
alias gaa='git add . '
alias gc='git clone '
alias gco='git commit '
alias gp='git pull '

# devel
alias p='python '
alias py='python3 '
alias st='subl '
alias nstart='npm start '
alias ni='npm i '
alias nis='npm i --save '
alias nisd='npm i --save-dev '
alias nig='npm i -g '
alias nug='npm u -g '
alias npmli='npm list -g --depth=0'
alias xampp_gui='cd /opt/lampp && sudo ./manager-linux-x64.run && cd ~'
alias xampp_start='cd /opt/lampp && sudo ./xampp start && cd ~'
alias xampp_stop='cd /opt/lampp && sudo ./xampp stop && cd ~'

# updating stuff
alias rup='GITHUB_OAUTH_TOK="$TOKEN" && filename="./pull_repos.sh" && rm -f $filename; curl -s https://raw.githubusercontent.com/cyfrost/dotfiles/master/pull_repos.sh >> "$filename"; chmod +x $filename && $filename $GITHUB_OAUTH_TOK && rm -f $filename'

# nav
alias ~='cd ~'
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias n='open'
alias start='open'
alias repos='cd ~/repos '

# proc
alias sigterm='sudo pkill -SIGTERM '
alias sigkill='sudo pkill -SIGKILL '
alias stoppid='sudo kill -SIGTERM '
alias killpid='sudo kill -SIGKILL '

# misc
alias d='kdiff3 '
alias r='source ~/.zshrc'
alias c='tput reset'
alias e='exit'
alias search='sudo updatedb && locate '
alias rmd='sudo rm -rf '
alias s='sudo systemctl'
alias h='r && history'
alias j='jobs -l'
alias ping='ping -c 5 google.com'
alias mem='free -mlht'
alias lock='dbus-send --type=method_call --dest=org.gnome.ScreenSaver /org/gnome/ScreenSaver org.gnome.ScreenSaver.Lock'
alias l='ls -AltchF --color=auto --group-directories-first --classify --time-style=+"%Y-%m-%d %H:%M" '
alias g='grep -i --color=auto '
alias v='vim '
alias fs='df -hlT --exclude-type=tmpfs --exclude-type=devtmpfs '
alias cls='clear '
alias clr='clear '
alias chrome='google-chrome '
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
alias ipe='msg "External IP: $(curl -s ipinfo.io/ip)"'
alias esshc='vim ~/.ssh/config '
alias ebrc='subl ~/.zshrc '
alias ealiasconfig='vim ~/.zshrc '
alias f='fuck'

# tmux
alias tn='tmux new-session -s '
alias ta='tmux attach -t '
alias tl='tmux ls '
alias tk='tmux kill-session -s '

# termux aliases
alias trup='token="$TOKEN" && curl -s "https://raw.githubusercontent.com/cyfrost/dotfiles/master/pull_repos.sh" | sed -e "s|^REPOS_DIR=.*|REPOS_DIR="/sdcard/repos/"|g" | bash -s $token && printf "\n\nDone! \n\n\n"'
alias tu="termux-setup-storage; apt update -y; apt upgrade -y; pkg update -y; pkg upgrade -y;"
alias tins="pkg install -y "

alias upload_history='upload_to_github "$HOME/.bash_history"'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
