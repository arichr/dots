function pkginstall
	sudo pacman -S $argv[1] --print 2>/dev/null >/dev/null
	if [ $status -eq 0 ]
		sudo pacman -S $argv[1] --print 2>/dev/null >~/.Packages/package-$argv[1].log
		sudo pacman -S $argv[1]
	end
end
