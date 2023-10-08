function pyinit
	echo ':: Copying template files...'
	cp -R ~/python-template/$(/bin/ls -1A ~/python-template/ -I venv -I '*.lock' -I .git) .
	echo ':: Creating "venv"...'
	mkv
end
