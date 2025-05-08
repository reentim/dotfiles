.PHONY: nodejs
nodejs: $(ASDF_DIR)/shims/node
	@if ! node --version > /dev/null 2>&1; then \
		echo "asdf set --home nodejs latest"; \
		asdf set --home nodejs latest; \
	fi

$(ASDF_DIR)/shims/node: $(ASDF_DIR)/plugins/nodejs
	$(ASDF_INSTALL_LATEST_NODEJS_CMD)

$(ASDF_DIR)/plugins/nodejs: $(DOTFILES_DIR)/bin/asdf
	asdf plugin add nodejs

.PHONY: asdf-install-latest-nodejs
asdf-install-latest-nodejs:
	$(ASDF_INSTALL_LATEST_NODEJS_CMD)

ASDF_INSTALL_LATEST_NODEJS_CMD = @{ \
	echo "Installing latest nodejs with asdf..."; \
	asdf install nodejs latest; \
}
