function fish_greeting
	if [ -z "$VIRTUAL_ENV" ]; and [ $SHLVL -eq 1 ]; and [ ! $FISH_GREETING ]
		neofox cat
		set -g FISH_GREETING 1
	else if [ ! $TERM_PROGRAM ]
		set_color cyan
		echo " > This is a #$SHLVL shell."
		set_color normal
	end
end
