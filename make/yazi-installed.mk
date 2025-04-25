YAZI_PACKAGES := \
	yazi \
	ffmpeg \
	7zip \
	jq \
	poppler \
	fd \
	ripgrep \
	fzf \
	zoxide \
	imagemagick \

yazi-installed:
	@$(MAKE) install-packages PACKAGES="$(YAZI_PACKAGES)"
