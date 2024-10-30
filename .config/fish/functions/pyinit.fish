function pyinit
    set -l template_dir "$HOME/python-template"

    echo ':: Copying template files...'
    cp -R $template_dir/$(/bin/ls -1A $template_dir -I venv -I '*.lock' -I .git) .
    echo ':: Creating "venv"...'
    mkv
end
