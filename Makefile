packages:
	-rm packages.*
	pacman -Qqent > packages.`date +%g%m%d%M`
