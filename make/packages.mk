PACKAGES := \
	btop \
	build-essential \
	curl \
	git \
	silversearcher-ag \
	tree \
	zsh \

UPDATE_STAMP := .packages-updated-stamp

ifeq ($(shell uname),Darwin)
	PKG_MANAGER := brew
else
	PKG_MANAGER := apt
endif

.PHONY: install-packages
install-packages: packages-update $(PACKAGES)

.PHONY: packages-update
packages-update: $(UPDATE_STAMP)

.PHONY: $(PACKAGES)
$(PACKAGES):
	@if [ "$(PKG_MANAGER)" = "apt" ]; then \
		if ! dpkg -s $@ >/dev/null 2>&1; then \
			echo "Installing $@..."; \
			$(call indent_output, sudo apt-get install -y $@); \
		fi; \
	elif [ "$(PKG_MANAGER)" = "brew" ]; then \
		if ! brew list --versions $@ >/dev/null 2>&1; then \
			echo "Installing $@..."; \
			$(call indent_output, brew install $@); \
		fi; \
	else \
		echo "Unsupported package manager: $(PKG_MANAGER)"; \
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
		else \
			echo "	Unsupported package manager: $(PKG_MANAGER)"; exit 1; \
		fi; \
		touch $@; \
	else \
		echo "	Skipping update (recent enough)"; \
	fi
