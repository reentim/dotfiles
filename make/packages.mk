PACKAGES := \
	btop \
	curl \
	git \
	tree \
	zsh \
	libyaml

APT_PACKAGES := \
	build-essential \
	silversearcher-ag \

PAC_PACKAGES := \
	colordiff \
	dnsutils \
	lsof \
	the_silver_searcher \
	github-cli \
	podman \
	tig \
	direnv \

UPDATE_STAMP := ~/.packages-updated-stamp

ifeq ($(shell uname),Darwin)
	PKG_MANAGER := brew
else ifeq ($(shell uname),Linux)
	ifneq ($(wildcard /etc/os-release),)
		OS_ID := $(shell source /etc/os-release && echo $$ID)
		ifeq ($(OS_ID),ubuntu)
			PKG_MANAGER := apt
			PACKAGES := $(PACKAGES) $(APT_PACKAGES)
		else ifeq ($(OS_ID),arch)
			PKG_MANAGER := pacman
			PACKAGES := $(PACKAGES) $(PAC_PACKAGES)
		endif
	endif
endif

.PHONY: install-packages
install-packages: packages-update $(PACKAGES)

.PHONY: packages-update
packages-update: $(UPDATE_STAMP)

.PHONY: $(PACKAGES)
$(PACKAGES):
	@if [ "$(PKG_MANAGER)" = "apt" ]; then \
		if ! dpkg -s $@ > /dev/null 2>&1; then \
			echo "Installing $@..."; \
			$(call indent_output, sudo apt-get install -y $@); \
		fi; \
	elif [ "$(PKG_MANAGER)" = "brew" ]; then \
		if ! brew list --versions $@ > /dev/null 2>&1; then \
			echo "Installing $@..."; \
			$(call indent_output, brew install $@); \
		fi; \
	elif [ "$(PKG_MANAGER)" = "pacman" ]; then \
		if ! pacman -T $@ > /dev/null 2>&1; then \
			echo "Installing $@..."; \
			$(call indent_output, sudo pacman -S --needed --noconfirm $@); \
		fi; \
	else \
		echo "ERROR: Unsupported package manager"; \
		exit 1; \
	fi

$(UPDATE_STAMP):
	@echo "Checking if package index update is needed..."
	@if [ ! -f $@ ] || [ "$$(find $@ -mmin +1440)" ]; then \
		echo "	Updating package index..."; \
		if [ "$(PKG_MANAGER)" = "apt" ]; then \
			$(call indent_output, sudo apt-get update); \
		elif [ "$(PKG_MANAGER)" = "brew" ]; then \
			$(call indent_output, brew update); \
		elif [ "$(PKG_MANAGER)" = "pacman" ]; then \
			$(call indent_output, pacman -y); \
		else \
			echo "ERROR: Unsupported package manager: $(PKG_MANAGER)"; \
			exit 1; \
		fi; \
		touch $@; \
	else \
		echo "	Skipping update (recent enough)"; \
	fi
