MAKEFLAGS += --no-print-directory

EXCLUDE := \
	Library \
	Makefile \
	README.md \
	config \
	make \
	src \

DOTFILES_DIR := $(shell dirname $(realpath Makefile))
ASDF_DIR := $(HOME)/.asdf
LINKABLES := $(filter-out $(EXCLUDE), $(shell find * -maxdepth 0) $(shell find config/* -maxdepth 0 -type d))
LINK_VISIBLY := bin

define indent_output
	$(1) | sed 's/^/    /'
endef

all: link-all

.PHONY: install
install: \
	link-all \
	install-asdf \
	install-packages \
	nodejs \
	pnpm \
	bun \
	neovim \
	ruby \
	src-compiled \
	# end

include make/packages.mk
include make/asdf.mk
include make/src-compiled.mk

.PHONY: clean
clean: unlink-all

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

unlink-all:
	@for file in $(LINKABLES); do \
	    source=$(DOTFILES_DIR)/$$file; \
	    if echo "$(LINK_VISIBLY)" | grep -qw "$$file"; then \
	        link=$(HOME)/$$file; \
	    else \
	        link=$(HOME)/.$$file; \
	    fi; \
	    $(MAKE) unlink-one SOURCE=$$source LINK=$$link; \
	done

macos-keybindings:
	@mkdir -p $(HOME)/Library/KeyBindings
	@$(MAKE) link-one \
		SOURCE=$(DOTFILES_DIR)/Library/KeyBindings/DefaultKeyBinding.dict \
		LINK=$(HOME)/Library/KeyBindings/DefaultKeyBinding.dict

.PHONY: link-one
link-one:
	@if [ -L $(LINK) ]; then \
	    existing_target=$$(readlink $(LINK)); \
	    if [ ! "$$existing_target" = "$(SOURCE)" ]; then \
	        echo "ABORT: $(LINK) exists but points to $$existing_target instead of $(SOURCE)!" >&2; \
	        exit 1; \
	    fi; \
	elif [ -e $(LINK) ]; then \
	    echo "ABORT: $(LINK) exists but is not a symlink!" >&2; \
	    exit 1; \
	else \
	    ln -s $(SOURCE) $(LINK); \
	    echo "Created symlink: $(LINK) -> $(SOURCE)"; \
	fi

.PHONY: unlink-one
unlink-one:
	@if [ -L $(LINK) ]; then \
	    existing_target=$$(readlink $(LINK)); \
	    if [ "$$existing_target" = "$(SOURCE)" ]; then \
	        rm $(LINK); \
	        echo "Removed symlink: $(LINK)"; \
	    else \
	        echo "ERROR: $(LINK) is a symlink but points to $$existing_target instead of $(SOURCE)! Aborting." >&2; \
	        exit 1; \
	    fi; \
	fi
