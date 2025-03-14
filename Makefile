MAKEFLAGS += --no-print-directory

DOTFILES_DIR := $(shell dirname $(realpath Makefile))
ICLOUD_DRIVE := $(HOME)/Library/Mobile\ Documents/com~apple~CloudDocs
ASDF_DIR := $(HOME)/.asdf

EXCLUDE := Makefile make Rakefile README.md config .gitmodules ssh Library iTerm babushka-deps
LINK_VISIBLY := bin lib
LINKABLES := $(filter-out $(EXCLUDE), $(shell find * -maxdepth 0) $(shell find config/* -maxdepth 0 -type d))

define indent_output
	$(1) | sed 's/^/    /'
endef

.PHONY: default
default: install

.PHONY: install
install: \
	link-all \
	install-packages \
	set-shell \
	nodejs \
	$(DOTFILES_DIR)/bin/monotonic-clock

include make/packages.mk

.PHONY: set-shell
set-shell:
	@if [ "$$SHELL" != "$(shell which zsh)" ]; then \
		echo "Attempting to change the default shell to zsh for the current user..."; \
		if grep -q "$(shell which zsh)" /etc/shells; then \
			echo "Shell is valid, changing to zsh..."; \
			sudo chsh -s "$(shell which zsh)" "$(shell whoami)"; \
			if [ $? -ne 0 ]; then \
    				echo "Error: something went wrong." >&2; \
    				exit 1; \
			fi; \
		else \
			echo "zsh is not listed in /etc/shells."; \
			echo "Please run the following commands manually to add it:"; \
			echo "  sudo echo $(shell which zsh) >> /etc/shells"; \
			echo "  chsh -s $(shell which zsh)"; \
		fi; \
	fi

$(DOTFILES_DIR)/bin/monotonic-clock: $(DOTFILES_DIR)/lib/monotonic-clock.c
	@gcc $< -o $@
	@echo "Built monotonic-clock.\n"

nodejs: $(ASDF_DIR)/shims/node

$(ASDF_DIR)/shims/node: \
	$(ASDF_DIR)/plugins/nodejs \
	$(ASDF_INSTALL_LATEST_NODEJS_CMD)

ASDF_INSTALL_LATEST_NODEJS_CMD = @{ \
	echo "Installing latest nodejs with asdf..."; \
	asdf install nodejs latest; \
}

.PHONY: asdf_install_latest_nodejs
asdf_install_latest_nodejs:
	$(ASDF_INSTALL_LATEST_NODEJS_CMD)

$(ASDF_DIR)/plugins/nodejs: $(DOTFILES_DIR)/bin/asdf
	asdf plugin add nodejs

$(DOTFILES_DIR)/bin/asdf:
	$(INSTALL_ASDF_CMD)

.PHONY: install_asdf
install_asdf:
	$(INSTALL_ASDF_CMD)

INSTALL_ASDF_CMD = @{ \
	echo "Installing latest asdf release..."; \
	set -e; \
	LATEST_RELEASE=$$(curl -fsSL -o /dev/null -w '%{url_effective}' https://github.com/asdf-vm/asdf/releases/latest | sed 's|.*/tag/v||'); \
	PLATFORM=$$(uname -s | tr '[:upper:]' '[:lower:]')-$$(uname -m); \
	case "$$PLATFORM" in \
	  "darwin-x86_64") PLATFORM="darwin-amd64" ;; \
	  "darwin-arm64")  PLATFORM="darwin-arm64" ;; \
	  "linux-x86_64")  PLATFORM="linux-amd64"  ;; \
	  "linux-aarch64") PLATFORM="linux-arm64"  ;; \
	esac; \
	INSTALL_DIR=$(HOME)/bin; \
	TARBALL=asdf-v$$LATEST_RELEASE-$$PLATFORM.tar.gz; \
	DOWNLOAD_URL=https://github.com/asdf-vm/asdf/releases/download/v$$LATEST_RELEASE/$$TARBALL; \
	echo "	Detected latest version: v$$LATEST_RELEASE"; \
	echo "	Detected platform: $$PLATFORM"; \
	echo "	Downloading: $$DOWNLOAD_URL"; \
	mkdir -p "$$INSTALL_DIR"; \
	curl -fsSL -o "$$TARBALL" "$$DOWNLOAD_URL"; \
	echo "	Extracting $$TARBALL to $$INSTALL_DIR..."; \
	tar -xzf "$$TARBALL" -C "$$INSTALL_DIR"; \
	rm "$$TARBALL"; \
	echo "	✅ asdf installed successfully in $$INSTALL_DIR!"; \
}

switch-nvim:
	@if [ -z "$(NAMESPACE)" ]; then \
		echo "ABORT: No namespace provided. Use \`make switch_nvim NAMESPACE=value\`."; exit 1; \
	fi
	@if pgrep -x nvim > /dev/null; then \
		echo "ABORT! nvim process detected"; exit 1; \
	fi
	@for path in .config/nvim .local/share/nvim .cache/nvim; do \
		link=$(HOME)/$$path; \
		source=$(HOME)/$$path.$(NAMESPACE); \
		[ -L $$link ] && rm $$link; \
		if [ -e $$link ]; then \
			echo "Found non-symlink $$link, moving to $$link.default"; \
	   		mv $$link $$link.default; \
		fi; \
		$(MAKE) link-one SOURCE=$$source LINK=$$link; \
	done

.PHONY: link-all
link-all:
	@for file in $(LINKABLES); do \
		source=$(DOTFILES_DIR)/$$file; \
		if echo "$(LINK_VISIBLY)" | grep -qw "$$file"; then \
			link=$(HOME)/$$file; \
		else \
			link=$(HOME)/.$$file; \
		fi; \
		$(MAKE) link-one SOURCE=$$source LINK=$$link; \
	done; \
	$(MAKE) link-one SOURCE=$(DOTFILES_DIR)/tmux/colors/themes/tokyo_night.conf LINK=$(DOTFILES_DIR)/tmux/colors/theme.conf

unlink:
	@for file in $(LINKABLES); do \
	    source=$(DOTFILES_DIR)/$$file; \
	    if echo "$(LINK_VISIBLY)" | grep -qw "$$file"; then \
	        link=$(HOME)/$$file; \
	    else \
	        link=$(HOME)/.$$file; \
	    fi; \
	    $(MAKE) unlink-one SOURCE=$$source LINK=$$link; \
	done

ssh:
	@mkdir -p $(HOME)/.ssh
	@for file in $(shell ls ssh/); do \
		$(MAKE) link-one SOURCE=$(DOTFILES_DIR)/ssh/$$file LINK=$(HOME)/.ssh/$$file; \
	done

keybindings:
	@mkdir -p $(HOME)/Library/KeyBindings
	@$(MAKE) link-one SOURCE=$(DOTFILES_DIR)/Library/KeyBindings/DefaultKeyBinding.dict LINK=$(HOME)/Library/KeyBindings/DefaultKeyBinding.dict

terminals:
	@for terminfo in $(shell ls terminals/); do \
		tic $(DOTFILES_DIR)/terminals/$$terminfo; \
	done

link-icloud-drive:
	@$(MAKE) link-one SOURCE=$(ICLOUD_DRIVE) LINK=$(HOME)/iCloud-Drive

link-lib:
	@$(MAKE) link-one SOURCE=$(DOTFILES_DIR)/lib LINK=$(HOME)/lib

link-dev:
	@$(MAKE) link-one SOURCE=$(ICLOUD_DRIVE)/dev LINK=$(HOME)/dev

link-journals:
	@$(MAKE) link-one SOURCE=$(ICLOUD_DRIVE)/journals LINK=$(HOME)/journals

.PHONY: link-one
link-one:
	@if [ -L $(LINK) ]; then \
	    existing_target=$$(readlink $(LINK)); \
	    if [ ! "$$existing_target" = "$(SOURCE)" ]; then \
	        echo "ERROR: $(LINK) exists but points to $$existing_target instead of $(SOURCE)! Aborting." >&2; \
	        exit 1; \
	    fi; \
	elif [ -e $(LINK) ]; then \
	    echo "ERROR: $(LINK) exists but is not a symlink! Aborting." >&2; \
	    exit 1; \
	else \
	    ln -s $(SOURCE) $(LINK); \
	    echo "Created symlink: $(LINK) -> $(SOURCE)"; \
	fi

unlink-one:
	@if [ -L $(LINK) ]; then \
	    existing_target=$$(readlink $(LINK)); \
	    if [ "$$existing_target" = "$(SOURCE)" ]; then \
	        rm $(LINK); \
	        echo "Removed symlink: $(LINK) -> $(SOURCE)"; \
	    else \
	        echo "ERROR: $(LINK) is a symlink but points to $$existing_target instead of $(SOURCE)! Aborting." >&2; \
	        exit 1; \
	    fi; \
	fi
