# Makefile for docker-loop-and-crash

###
 # configuration
###
.DEFAULT_GOAL := help

# colorize some of the output, see http://dcmnt.me/1XYnkPe for more information
COLOR_OFF = \x1b[0m
COLOR_OK = \x1b[32;01m
COLOR_ERR = \x1b[31;01m
COLOR_MUTE = \x1b[30;01m
COLOR_BRIGHT = \x1b[37;01m

# image-specific variables
IMAGE_ORG="cultivatedops"
IMAGE_NAME=$(shell cat "Dockerfile" | grep "ENV APP_NAME" | tr -d "ENV APP_NAME")
IMAGE_VERSION=$(shell cat "Dockerfile" | grep "ENV APP_VERSION" | tr -d "ENV APP_VERSION")

GIT_COMMIT = $(strip $(shell git rev-parse --short HEAD))

###
 # Targets
###
.PHONY: help
help:
	@echo
	@echo "$(COLOR_BRIGHT)"
	@echo "    _____                   _                   "
	@echo "   |  __ \                 | |                  "
	@echo "   | |  | |   ___     ___  | | __   ___   _ __  "
	@echo "   | |  | |  / _ \   / __| | |/ /  / _ \ | '__| "
	@echo "   | |__| | | (_) | | (__  |   <  |  __/ | |    "
	@echo "   |_____/   \___/   \___| |_|\_\  \___| |_|    "
	@echo "                                                "
	@echo "                        	$(COLOR_MUTE)loop-and-crash$(COLOR_MUTE) "
	@echo "$(COLOR_OFF)"
	@echo
	@echo	"$(COLOR_BRIGHT)   Options:$(COLOR_OFF)"
	@echo "     make test $(COLOR_MUTE)..........$(COLOR_OFF) runs RSpec tests"
	@echo "     make build $(COLOR_MUTE).........$(COLOR_OFF) builds image"
	@echo "     make push $(COLOR_MUTE)..........$(COLOR_OFF) pushes image to registry"
	@echo


.PHONY: test
test:
	@bundle \
		install \
	&& \
	bundle \
		exec --verbose rspec --color

.PHONY: build
build:
	@docker \
		build \
			--no-cache \
			--build-arg VCS_URL=`git config --get remote.origin.url` \
			--build-arg VCS_REF="$(GIT_COMMIT)" \
		  --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
			--tag="$(IMAGE_ORG)/$(IMAGE_NAME):$(IMAGE_VERSION)" \
			.
