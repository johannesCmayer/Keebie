SHELL=/bin/bash

bin_path="/usr/bin/keebie"
install_path="/usr/share/keebie/"

pkg_type="tar"

maintainer="Michael Basaj <michaelbasaj@protonmail.com>"
version="1.1.0"
iteration="0"
# .SILENT:

pre-pkg: check-for-changes


pkg: pre-pkg 
	fpm --verbose -f \
	-t $(pkg_type) \
	-s dir \
	-a all \
	-p ../ \
	-n keebie \
	-d python3 -d python3-evdev \
	--maintainer $(maintainer) \
	--version $(version) \
	--iteration $(iteration) \
	--license "none (yet)" \
	--url https://github.com/robinuniverse/Keebie \
	--description "A keyboard macro utility for Linux." \
	--exclude "*.keep" \
	./keebie.py=$(bin_path) \
	./layers/=$(install_path)/data/layers \
	./settings.json=$(install_path)/data/ \
	./devices/=$(install_path)/data/devices \
	./scripts/=$(install_path)/data/scripts \
	./setup_tools/=$(install_path)/setup_tools

	# --before-install "./packaging/preinst" \
	# --after-install "./packaging/postinst" \
	# --before-install "./packaging/prerm" \
	# --after-remove "./packaging/postem" \


check-for-changes:
	@echo "MODIFIED FILES"
	@git status --porcelain | grep -E "^ ?M" || echo "None"

	@echo "NEW FILES"
	@git status --porcelain | grep -E "^ ?\?" || echo "None"

	@echo "DELETED FILES"
	@git status --porcelain | grep -E "^ ?D" || echo "None"


install:
	sudo cp -v ./keebie.py $(bin_path)

	sudo mkdir -pv $(install_path)/data/ $(install_path)/setup_tools/

	sudo cp -rv -t $(install_path)/data/ ./layers/ ./settings.json ./devices/ ./scripts/
	sudo cp -rv -t $(install_path)/ ./setup_tools/


remove:
	sudo rm -rfv $(bin_path) $(install_path)