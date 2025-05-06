VERSION := "10.9.0"

.PHONY: pnpm
pnpm: $(ASDF_DIR)/shims/pnpm
	@if ! pnpm --version > /dev/null 2>&1; then \
		echo "asdf set --home pnpm $(VERSION)"; \
		asdf set --home pnpm $(VERSION); \
	fi

$(ASDF_DIR)/shims/pnpm: $(ASDF_DIR)/plugins/pnpm
	$(ASDF_INSTALL_LATEST_PNPM_CMD)

$(ASDF_DIR)/plugins/pnpm: $(DOTFILES_DIR)/bin/asdf
	asdf plugin add pnpm

ASDF_INSTALL_LATEST_PNPM_CMD = @{ \
	echo "Installing pnpm $(VERSION) with asdf..."; \
	asdf install pnpm $(VERSION); \
}
