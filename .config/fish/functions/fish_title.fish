function fish_title
	# emacs' "term" is basically the only term that can't handle it.
	if not set -q INSIDE_EMACS; or string match -vq '*,term:*' -- $INSIDE_EMACS
		if not set -gq TERM_NAME
			# Set a unique indentifier to each fish session
			set -l consonants q w r t p s d f g h j k l z x c v b n m
			set -l vowels e y u i o a
			set -l consonants_len $(count $consonants)
			set -l vowels_len $(count $vowels)
			set -gx TERM_NAME $consonants[$(random 1 $consonants_len)]$vowels[$(random 1 $vowels_len)]$consonants[$(random 1 $consonants_len)]$vowels[$(random 1 $vowels_len)]$consonants[$(random 1 $consonants_len)]$vowels[$(random 1 $vowels_len)]-$consonants[$(random 1 $consonants_len)]$vowels[$(random 1 $vowels_len)]$consonants[$(random 1 $consonants_len)]$vowels[$(random 1 $vowels_len)]
		end
		# If we're connected via ssh, we print the hostname.
		set -l ssh
		set -q SSH_TTY
		and set ssh "["(prompt_hostname | string sub -l 10 | string collect)"]"
		# An override for the current command is passed as the first parameter.
		# This is used by `fg` to show the true process name, among others.
		if set -q argv[1]
			echo -- "[$TERM_NAME]" $ssh (string sub -l 20 -- $argv[1]) (prompt_pwd -d 1 -D 1)
		else
			# Don't print "fish" because it's redundant
			set -l command (status current-command)
			if test "$command" = fish
				set command
			end
			echo -- "[$TERM_NAME]" $ssh (string sub -l 20 -- $command) (prompt_pwd -d 1 -D 1)
		end
	end
end
