export GPG_TTY=$(tty)
export EDITOR='nano'
export BROWSER='iceweasel'

# Aliases
alias pls="sudo"
alias please="sudo"
## General
alias ls='lsd --group-directories-first'
alias l='ls -A'
alias ll='ls -Alh'
alias findtodo='grep -Fri "TODO:" . && grep -Fri "BUG" . && grep -Fri "FIXME" .'
alias rmv='rm -v'
alias mvv='mv -v'
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
## C/C++
alias cppc='g++ -Wall -Werror=all -std=c++17'
alias cppcp='g++ -Wall -Werror=all -std=c++17 -fpermissive'
alias cppcpp='g++ -Wall -std=c++17 -fpermissive'
## Android
alias adbshot='adb shell screencap /sdcard/screenshot.png && adb pull /sdcard/screenshot.png screenshot.png'
## Network
alias nm-up="nmcli connection up"
alias nm-down="nmcli connection down"

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
function fsize --description "Get file size via ls"
	if [ -f "$argv[1]" ]
		/bin/ls -sh "$argv[1]"
	else if [ -n "$argv[1]" ]
		echo "Unable to locate file $argv[1]" 1>&2
		return 1
	else
		echo "Usage: fsize <file>" 1>&2
		return 1
	end
end

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
	set -l WG_STATUS

	if [ "$(grep en /etc/locale.conf)" ]
		set NMCLI_REGEX_ACTIVE '[^dis]connected'
	else if [ "$(grep en /etc/locale.conf)" ]
		set NMCLI_REGEX_ACTIVE '[^не\s]подключено'
	end
	set -l ACTIVE_INTERFACES "$(nmcli d | grep $NMCLI_REGEX_ACTIVE | awk 'BEGIN { ORS="" } { print p$1; p="'", "'" } END { print "'"\\n"'" }')"

	# It was tested only if it throws an error.
	if [ -n "$(wg 2>&1)" ]
		set -l WG_OUTPUT "$(wg 2>&1)"

		set wg_interfaces ""
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

	switch $argv[1]
		case 'cat'
			echo -e "\e[38;5;173;1m           __..--''\`\`---....___   _..._    __
/// //_.-'    .-/\";  \`        \`\`<._  \`\`.''_ \`. / // /
///_.-' _..--.'\e[38;5;42m_\e[38;5;173m    \                    \`( ) ) // //\e[38;5;174m    C A T\e[38;5;173m
/ (_..-' // (\e[38;5;172m<\e[38;5;173m \e[38;5;42m_\e[38;5;173m     ;_..__               ; \`' / ///\e[38;5;174m    I N F O\e[38;5;173m
/ // // //  \`-._,_)' // / \`\`--...____..-' /// / //\e[0m"
			echo -e "\e[1;92m>\e[97m \e[1mWireGuard:\e[0m $WG_STATUS"
			echo -e "\e[1;92m>\e[97m \e[1mActive interfaces:\e[0m $ACTIVE_INTERFACES"

		case 'fox'
			echo -e "\e[38;5;173;1m   |\\__/|             \e[38;5;42;1m> \e[38;5;178;1mNetwork:\e[38;5;173m
   /    \\              \e[38;5;170mWireGuard:\e[0m $WG_STATUS\e[38;5;173;1m
  /_.~ ~_\\  \e[38;5;174mF O X\e[38;5;173m      \e[38;5;170mActive:\e[0m $ACTIVE_INTERFACES\e[38;5;173;1m
     \\@/\e[0m"

		case '*'
			echo "Unable to apply styles to Neofox." 1>&2
			return 1
	end
end

source ~/.config/fish/private.fish
