OPT_DIR=/usr/local/opt/paddington
BIN=/usr/local/bin/paddington

all: lib/* config/* mix.exs
	mix local.hex
	mix deps.get
	mix compile

install:
	@echo "Copying paddington folder..."
	@mkdir $(OPT_DIR)
	@cp -r * $(OPT_DIR)

	@echo "Installing paddington executable..."
	@echo "#!/bin/sh\n"                  > $(BIN)
	@echo "cd $(OPT_DIR) > /dev/null"    >> $(BIN)
	@echo "source $(OPT_DIR)/bin/paddington" >> $(BIN)

	@chmod +x $(BIN)
	@echo "Done!"

uninstall:
	@echo "Removing paddington folder..."
	@rm -rf $(OPT_DIR)
	@rm $(BIN)
	@echo "Done!"
