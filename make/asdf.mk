include make/asdf/nodejs.mk
include make/asdf/neovim.mk
include make/asdf/ruby.mk
include make/asdf/pnpm.mk
include make/asdf/bun.mk

.PHONY: install-asdf
install-asdf: install-packages
	$(INSTALL_ASDF_CMD)

/usr/local/bin/asdf:
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
	INSTALL_DIR=/usr/local/bin; \
	TARBALL=asdf-v$$LATEST_RELEASE-$$PLATFORM.tar.gz; \
	DOWNLOAD_URL=https://github.com/asdf-vm/asdf/releases/download/v$$LATEST_RELEASE/$$TARBALL; \
	echo "	Detected latest version: v$$LATEST_RELEASE"; \
	echo "	Detected platform: $$PLATFORM"; \
	echo "	Downloading: $$DOWNLOAD_URL"; \
	sudo mkdir -p "$$INSTALL_DIR"; \
	curl -fsSL -o "/tmp/$$TARBALL" "$$DOWNLOAD_URL"; \
	echo "	Extracting /tmp/$$TARBALL to $$INSTALL_DIR..."; \
	sudo tar -xzf "/tmp/$$TARBALL" -C "$$INSTALL_DIR"; \
	echo "	✅ asdf installed successfully in $$INSTALL_DIR!"; \
}
