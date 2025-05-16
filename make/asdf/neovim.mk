.PHONY: neovim
neovim: $(ASDF_DIR)/shims/nvim
	asdf set --home neovim latest

$(ASDF_DIR)/shims/nvim: $(ASDF_DIR)/plugins/neovim
	$(ASDF_INSTALL_LATEST_NEOVIM_CMD)

$(ASDF_DIR)/plugins/neovim: /usr/local/bin/asdf
	asdf plugin add neovim

.PHONY: asdf-install-latest-neovim
asdf-install-latest-neovim:
	$(ASDF_INSTALL_LATEST_NEOVIM_CMD)

ASDF_INSTALL_LATEST_NEOVIM_CMD = @{ \
	echo "Installing latest neovim with asdf..."; \
	asdf install neovim latest; \
}
