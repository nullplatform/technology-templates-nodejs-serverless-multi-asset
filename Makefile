#
# Makefile for processing assets
#
# This Makefile is designed to receive parameters that control its behavior.
# It helps manage assets by processing them in a specified working directory
# and outputting the results to a designated asset output directory.

# Parameter: ASSET_WORKING_DIRECTORY
# This is the directory where the assets will be processed from.
# This variable is set to the path of the directory containing your source assets.

# Parameter: ASSET_OUTPUT_DIRECTORY
# This is the directory where the processed assets will be stored.
# This variable is set to the path of the directory where the processed assets will be saved.

# Parameter: ASSET_TARGET_URL
# The remote repository URL where the processed assets will be pushed or deployed.
# This variable is set to the URL of the destination repository.

# Parameter: ASSET_NAME
# The name of the asset being processed. It is used to create the ASSET_FILE.

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
