ASSET_FILE=$(ASSET_NAME).zip

.PHONY: all clean build setup test compile package push

all: clean build push
build: setup test compile package

clean:
	rm -r $(ASSET_OUTPUT_DIRECTORY)
setup:
	mkdir -p $(ASSET_OUTPUT_DIRECTORY)
	cp $(ASSET_WORKING_DIRECTORY)/package.json $(ASSET_OUTPUT_DIRECTORY)
	npm --prefix $(ASSET_OUTPUT_DIRECTORY) install
test:
	npm --prefix $(ASSET_OUTPUT_DIRECTORY) run test
compile:
	npm --prefix $(ASSET_OUTPUT_DIRECTORY) prune --production
	cp $(ASSET_WORKING_DIRECTORY)/*.js $(ASSET_OUTPUT_DIRECTORY)
package:
	cd $(ASSET_OUTPUT_DIRECTORY) && zip -r $(ASSET_FILE) .
push:
	aws s3 cp $(ASSET_OUTPUT_DIRECTORY)/$(ASSET_FILE) $(ASSET_TARGET_URL)
