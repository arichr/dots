function goinit
	if [ -z $argv[1] ]
		echo ':: Invalid project name.' 1>&2
		return 1
	end
	set -f project_name (string replace -a ' ' '-' "$(string lower "$argv")")

	mkdir "$argv"                                        \
	&& cd "$argv"                                        \
	&& go mod init example.com/$project_name             \
	&& mkdir -p pkg/$project_name                        \
	&& mkdir -p internal                                 \
	&& mkdir -p cmd/$project_name                        \
	&& echo ":: Created project '$project_name' ($argv)"
end
