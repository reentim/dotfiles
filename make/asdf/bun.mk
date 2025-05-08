.PHONY: bun
bun: $(ASDF_DIR)/shims/bun
	@if ! bun --version > /dev/null 2>&1; then \
		echo "asdf set --home bun latest"; \
		asdf set --home bun latest; \
	fi

$(ASDF_DIR)/shims/bun: $(ASDF_DIR)/plugins/bun
	$(ASDF_INSTALL_LATEST_BUN_CMD)

$(ASDF_DIR)/plugins/bun: $(DOTFILES_DIR)/bin/asdf
	asdf plugin add bun

ASDF_INSTALL_LATEST_BUN_CMD = @{ \
	echo "Installing bun with asdf..."; \
	asdf install bun latest; \
}
