#
# Makefile
#

.PHONY: help build
.DEFAULT_GOAL := help


help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# ----------------------------------------------------------------------------------------------------------------

install: ## Installs all dependencies
	curl -O https://orca:Z3ssZaDmE7vK@orca-build.io/downloads/orca.zip
	unzip -o orca.zip
	rm -f orca.zip

generate: ## Generates all artifacts for this image
	@php orca.phar --directory=.

clear: ## Clears all dangling images
	docker images -aq -f 'dangling=true' | xargs docker rmi
	docker volume ls -q -f 'dangling=true' | xargs docker volume rm

build: ## Builds the provided tag [image=play tag=6.1.6]
ifndef tag
	$(warning Provide the required image tag using "make build image=play tag=6.1.6")
	@exit 1;
else
	@cd ./dist/images/$(image)/$(tag) && docker build -t dockware/$(image):$(tag) .
endif
