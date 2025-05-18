PACKAGES := \
	btop \
	curl \
	git \
	libyaml \
	tree \

APT_PACKAGES := \
	build-essential \

PACMAN_PACKAGES := \
	bat \
	direnv \
	dnsutils \
	git-delta \
	github-cli \
	lazygit \
	libqalculate \
	lsof \
	moreutils \
	perf \
	podman \
	pspg \
	socat \
	tabulate \
	tig \
	zoxide \
	zsh \

HOMEBREW_PACKAGES := \
	coreutils \
	fzf \
	git-delta \
	ripgrep \
	zoxide \

UPDATE_STAMP := ~/.packages-updated-stamp

ifeq ($(shell uname),Darwin)
	PKG_MANAGER := brew
	PACKAGES := $(PACKAGES) $(HOMEBREW_PACKAGES)
else ifeq ($(shell uname),Linux)
	ifneq ($(wildcard /etc/os-release),)
		OS_ID := $(shell source /etc/os-release && echo $$ID)
		ifeq ($(OS_ID),ubuntu)
			PKG_MANAGER := apt
			PACKAGES := $(PACKAGES) $(APT_PACKAGES)
		else ifeq ($(OS_ID),arch)
			PKG_MANAGER := pacman
			PACKAGES := $(PACKAGES) $(PACMAN_PACKAGES)
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
	@if [ ! -f $@ ] || [ "$$(find $@ -mmin +1440)" ]; then \
		echo "	Package list is more than 1 day old, updating..."; \
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
	fi
