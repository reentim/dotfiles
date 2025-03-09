.PHONY: neovim
neovim: $(ASDF_DIR)/shims/nvim
	@if ! nvim --version > /dev/null 2>&1; then \
		echo "asdf set --home neovim latest"; \
		asdf set --home neovim latest; \
	fi; \
	$(MAKE) switch-nvim NAMESPACE=reentim

$(ASDF_DIR)/shims/nvim: $(ASDF_DIR)/plugins/neovim
	$(ASDF_INSTALL_LATEST_NEOVIM_CMD)

$(ASDF_DIR)/plugins/neovim: $(DOTFILES_DIR)/bin/asdf
	asdf plugin add neovim

.PHONY: asdf-install-latest-neovim
asdf-install-latest-neovim:
	$(ASDF_INSTALL_LATEST_NEOVIM_CMD)

ASDF_INSTALL_LATEST_NEOVIM_CMD = @{ \
	echo "Installing latest neovim with asdf..."; \
	asdf install neovim latest; \
}
