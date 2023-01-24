export GPG_TTY=$(tty)
export EDITOR='nano'
export BROWSER='chromium.AppImage'

# Aliases
## General
alias ls='lsd --group-directories-first'
alias l='ls -A'
alias ll='ls -Alh'
alias todo='grep -Fri "TODO:" . && grep -Fri "BUG" . && grep -Fri "FIXME" .'
alias rm='rm -v'
## Pacman
alias pac='sudo pacman'
alias rmp='sudo pacman -Rcnsu'
alias findp='pacman -Ss'
alias findpf='pacman -F'
alias paconf="sudo $EDITOR /etc/pacman.conf"
## Python
alias py='python'
alias po='poetry'
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
function fsize --description "fsize <file>"
	if [ -f "$argv[1]" ]
		/bin/ls -sh "$argv[1]"
	else
		return 1
	end
end

alias webdir='python -m http.server 8080'

function neofox
	set -l WG_STATUS

	if [ "$(wg 2>&1)" ]
		set -l WG_OUTPUT "$(wg 2>&1)"
		
		set wg_interfaces ()
		for interface in (string split \n $WG_OUTPUT)
			echo $interface | string match -ar '(?:interface\s(?<interface>.*)\:)+' > /dev/null
			set -a wg_interfaces $interface
		end
		set wg_interfaces ( string replace ' ' ', ' "$wg_interfaces" )
		set WG_STATUS "Working! (\e[94m$wg_interfaces\e[0m)"
	else
		set WG_STATUS "\e[2mSleeping...\e[0m"
	end
	
	set -l ACTIVE_INTERFACES "$(nmcli d | grep '[^dis]connected' | awk 'BEGIN { ORS="" } { print p$1; p="'", "'" } END { print "'"\\n"'" }')"

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
			echo "Unable to apply styles to Neofox."
			return 1
	end
end
