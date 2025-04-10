MAKEFLAGS += --no-print-directory

DOTFILES_DIR := $(shell dirname $(realpath Makefile))
ICLOUD_DRIVE := $(HOME)/Library/Mobile\ Documents/com~apple~CloudDocs
ASDF_DIR := $(HOME)/.asdf

EXCLUDE := Makefile make README.md config .gitmodules ssh Library
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
	neovim \
	ruby \
	mail \
	$(DOTFILES_DIR)/bin/monotonic-clock \
	# end

include make/packages.mk
include make/asdf.mk

.PHONY: set-shell
set-shell:
	@if [ "$$SHELL" != "$(shell which zsh)" ]; then \
		echo "Attempting to change the default shell to zsh for the current user..."; \
		if grep -q "$(shell which zsh)" /etc/shells; then \
			echo "Shell is valid, changing to zsh..."; \
			sudo chsh -s "$(shell which zsh)" "$(shell whoami)"; \
			if [ $? -eq 0 ]; then \
				@echo "Error: something went wrong." >&2; \
				@echo "✅ Shell set to zsh"; \
			else \
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
	@echo "✅ Built monotonic-clock"

switch-nvim:
	@if [ -z "$(NAMESPACE)" ]; then \
		echo "ABORT: No namespace provided. Use \`make switch_nvim NAMESPACE=value\`."; exit 1; \
	fi
	@if ! basename $(shell readlink $(HOME)/.config/nvim) | grep "nvim.$(NAMESPACE)" > /dev/null; then \
		if pgrep -x nvim > /dev/null; then \
			echo "ABORT! nvim process detected"; exit 1; \
		fi; \
		for path in .config/nvim .local/share/nvim .cache/nvim; do \
			link=$(HOME)/$$path; \
			source=$(HOME)/$$path.$(NAMESPACE); \
			[ -d $$source ] || mkdir -p $$source; \
			if [ -L "$$link" ] && [ "$$(readlink "$$link")" != "$$source" ]; then \
				rm "$$link"; \
			fi; \
			if [ -e $$link ] && [ ! -L $$link ]; then \
				echo "Found non-symlink $$link, moving to $$link.default"; \
				mv "$$link" "$$link".default; \
			fi; \
			[ -L $$link ] || $(MAKE) link-one SOURCE=$$source LINK=$$link; \
		done; \
	fi

.PHONY: link-all
link-all:
	@mkdir -p $(HOME)/.config; \
	for file in $(LINKABLES); do \
		source=$(DOTFILES_DIR)/$$file; \
		if echo "$(LINK_VISIBLY)" | grep -qw "$$file"; then \
			link=$(HOME)/$$file; \
		else \
			link=$(HOME)/.$$file; \
		fi; \
		$(MAKE) link-one SOURCE=$$source LINK=$$link; \
	done; \

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

macos-keybindings:
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

.PHONY: mail
mail:
	@mkdir -p ~/.mail
	@touch ~/.mail/{inbox,sent}
