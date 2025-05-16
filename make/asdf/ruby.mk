.PHONY: ruby
ruby: $(ASDF_DIR)/shims/ruby
	@if ! ruby --version > /dev/null 2>&1; then \
		echo "asdf set --home ruby latest"; \
		asdf set --home ruby latest; \
	fi

$(ASDF_DIR)/shims/ruby: $(ASDF_DIR)/plugins/ruby
	$(ASDF_INSTALL_LATEST_RUBY_CMD)

$(ASDF_DIR)/plugins/ruby: $(DOTFILES_DIR)/bin/asdf
	asdf plugin add ruby

.PHONY: asdf-install-latest-ruby
asdf-install-latest-ruby: libyaml
	$(ASDF_INSTALL_LATEST_RUBY_CMD)

ASDF_INSTALL_LATEST_RUBY_CMD = @{ \
	echo "Installing latest ruby with asdf..."; \
	asdf install ruby latest; \
}
