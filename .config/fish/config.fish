export GPG_TTY=$(tty)
export EDITOR='nano'
export PAGER='most'
export BROWSER='iceweasel'

# Aliases
alias pls="sudo"
alias please="sudo"
## General
alias ls='lsd --group-directories-first'
alias l='ls -AFh'
alias ll='ls -AFlh --permission octal'
alias findtodo='grep -FIrin "TODO:" .; grep -FIrin "BUG:" . ; grep -FIrin "FIXME:" .'
alias rmv='rm -v'
alias mvv='mv -v'
alias fsize='ls -1Flh'
## Archives
alias tarcompress="tar --no-acls --no-selinux --no-xattrs --owner=0 --group=0 --mtime='@0' --sort=name --mode='-rw-' -cf"
alias zstcompress="tar --zstd --no-acls --no-selinux --no-xattrs --owner=0 --group=0 --mtime='@0' --sort=name --mode='-rw-' -cf"
alias paincompress='lrzip -z -o'
## Pacman
alias pac='sudo pacman'
alias rmp='sudo pacman -Rcnsu'
alias findp='pacman -Ss'
alias findpf='pacman -F'
alias paconf="sudo $EDITOR /etc/pacman.conf"
alias pautoremove="pacman -Qdtq | xargs sudo pacman -Rcnsu --confirm"
## Python
alias py='python'
alias po='poetry'
alias ruff_rules="ruff rule --all | grep '^# ' | awk '{ print $3 }' | grep -E '[A-Z]+' -o | awk '!seen[$0]++'"
## C/C++
alias strip_all='strip -s -g -d -S --strip-debug --strip-dwo --strip-unneeded -X'
## Android
alias adbshot='adb shell screencap /sdcard/screenshot.png && adb pull /sdcard/screenshot.png screenshot.png'
## Network
alias nm-up="nmcli connection up"
alias nm-down="nmcli connection down"
alias checkports="sudo lsof -nPEl -iTCP -iUDP"

function vrun --description "vrun <venv>"
    if [ -f "$argv[1]/bin/activate.fish" ]
        fish --command "source $argv[1]/bin/activate.fish; fish -i"
    else
        echo 'This is not a virtual environment.'
        return 1
    end
end

function mkv --description "mkv"
    if [ -f "venv/bin/activate.fish" ]
        echo -e "A virtual environment \e[91;1malready\e[0m exists."
    else
        python -m venv venv
        echo -e "\e[92;1m$(pwd)/venv/\e[0m created successfully."
    end
    vrun venv
end

## Useful
function child --description "Create a child process without stderr output"
    if [ -n "$argv" ]
        $argv 2>/dev/null &
        disown $last_pid 2>/dev/null
    else
        echo "Usage: child <command>" 1>&2
        return 1
    end
end

function qchild --description "Create a child process without any output"
    if [ -n "$argv" ]
        $argv >/dev/null 2>/dev/null &
        disown $last_pid 2>/dev/null
    else
        echo "Usage: qchild <command>" 1>&2
        return 1
    end
end

alias webdir='python -m http.server 8080'

## Neofox
function neofox
    set -l NMCLI_REGEX_ACTIVE
    if [ "$(grep en /etc/locale.conf)" ]
        set NMCLI_REGEX_ACTIVE '[^dis]connected'
    else if [ "$(grep ru /etc/locale.conf)" ]
        set NMCLI_REGEX_ACTIVE '[^не\s]подключено'
    end
    set -l ACTIVE_INTERFACES "$(nmcli d | grep $NMCLI_REGEX_ACTIVE | awk 'BEGIN { ORS="" } { print p$1; p="'", "'" } END { print "'"\\n"'" }')"

    set -l WG_STATUS
    # It was tested only if it throws an error.
    if [ -e "/usr/bin/wg" ]
        if [ -n "$(wg 2>&1)" ]
            set -l WG_OUTPUT "$(wg 2>&1)"

            set -l wg_interfaces ""
            for interface in (string split \n $WG_OUTPUT)
                echo $interface | string match -ar '(?:interface\s(?<interface>.*)\:)+' > /dev/null

                string match -i "*$interface*" "$ACTIVE_INTERFACES" 2>&1 1>/dev/null
                if [ $status -ne 0 ]
                    set interface ", \e[94m$interface\e[0m (\e[2mkilled\e[0m)"
                else
                    set interface ", \e[94m$interface\e[0m"
                end
                set wg_interfaces "$wg_interfaces$interface"
            end

            set wg_interfaces ( string sub -s 3 "$wg_interfaces" )
            set WG_STATUS "\e[95;2mWorking!\e[0m [$wg_interfaces]"
        else
            set WG_STATUS "\e[2mSleeping...\e[0m"
        end
    else
        set WG_STATUS "\e[2mNot found\e[0m"
    end

    set -l TOR_STATUS
    if [ -e "/usr/bin/tor" ]
        set TOR_STATUS "$(ps -C tor --no-headers s | awk '{ print $2 }')"
        if [ -n "$TOR_STATUS" ]
            set TOR_STATUS "\e[94mWorking! \e[95;2m(PID: $TOR_STATUS)\e[0m"
        else
            set TOR_STATUS "\e[2mSleeping...\e[0m"
        end
    else
        set TOR_STATUS "\e[2mNot found\e[0m"
    end

    switch $argv[1]
        case 'cat'
            echo -e "\e[38;5;173;1m           __..--''\`\`---....___   _..._    __
/// //_.-'    .-/\";  \`        \`\`<._  \`\`.''_ \`. / // /
///_.-' _..--.'\e[38;5;42m_\e[38;5;173m    \                    \`( ) ) // //\e[38;5;174m    C A T\e[38;5;173m
/ (_..-' // (\e[38;5;172m<\e[38;5;173m \e[38;5;42m_\e[38;5;173m     ;_..__               ; \`' / ///\e[38;5;174m    I N F O\e[38;5;173m
/ // // //  \`-._,_)' // / \`\`--...____..-' /// / //\e[0m"
            echo -e "\e[1;92m>\e[97m \e[1mWireGuard:\e[0m $WG_STATUS"
            echo -e "\e[1;92m>\e[97m \e[1mTor:\e[0m $TOR_STATUS"
            echo -e "\e[1;92m>\e[97m \e[1mActive interfaces:\e[0m $ACTIVE_INTERFACES"

        case 'fox'
            echo -e "\e[38;5;173;1m   |\\__/|             \e[38;5;42;1m> \e[38;5;178;1mNetwork:\e[38;5;173m"
            echo -e               "   /    \\              \e[38;5;170;1mWireGuard:\e[0m $WG_STATUS\e[38;5;173;1m"
            echo -e               "  /_.~ ~_\\  \e[38;5;174mF O X\e[38;5;173m      \e[38;5;170;1mTor:\e[0m $TOR_STATUS\e[38;5;173;1m"
            echo -e              "     \\@/\e[0m               \e[38;5;170;1mActive:\e[0m $ACTIVE_INTERFACES\e[38;5;173;1m"

        case '*'
            echo "Unable to apply styles to Neofox." 1>&2
            return 1
    end
end

source ~/.config/fish/private.fish
