BOX_NAME := noble64
OUTPUT_BOX := $(HOME)/$(BOX_NAME).box
METADATA_JSON := $(BOX_NAME)-metadata.json

.PHONY: all
all: create-box

.PHONY: create-box
create-box: \
	vagrant-provision \
	vagrant-package \
	vagrant-destroy \
	vagrant-add-box

.PHONY: vagrant-provision
vagrant-provision:
	STEP=1 vagrant up --provision
	vagrant halt
	STEP=2 vagrant up --provision
	vagrant halt

.PHONY: vagrant-package
vagrant-package:
	vagrant package --output $(OUTPUT_BOX)

.PHONY: vagrant-destroy
vagrant-destroy:
	vagrant destroy -f

.PHONY: vagrant-add-box
vagrant-add-box:
	vagrant box add $(METADATA_JSON)

.PHONY: clean
clean:
	rm -f $(OUTPUT_BOX)
	vagrant destroy -f
