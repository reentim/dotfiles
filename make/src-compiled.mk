BIN_DIR = bin
SRC_DIR = src/c

SOURCES = $(wildcard $(SRC_DIR)/*.c)
OUTPUTS = $(patsubst $(SRC_DIR)/%.c,$(BIN_DIR)/%, $(SOURCES))

$(BIN_DIR)/%: $(SRC_DIR)/%.c
	@gcc $< -o $@ -lm
	@echo "✅ Built $<"

.PHONY: src-compiled
src-compiled: $(OUTPUTS)
