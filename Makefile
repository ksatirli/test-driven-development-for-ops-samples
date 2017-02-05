# Makefile for test-driven-development-for-ops

###
 # configuration
###
.DEFAULT_GOAL := help

# colorize some of the output, see http://dcmnt.me/1XYnkPe for more information
STYLE_OFF = \x1b[0m
STYLE_OK = \x1b[32;01m
STYLE_ERR = \x1b[31;01m
STYLE_WARN = \x1b[33;01m
STYLE_MUTE = \x1b[30;01m
STYLE_BRIGHT = \x1b[37;01m
STYLE_OFF = \x1b[0m
STYLE_UNDERLINE = \x1b[4m

SIGN_OK = $(STYLE_OK)  ✓$(STYLE_OFF)
SIGN_ERR = $(STYLE_ERR)  ✗$(STYLE_OFF)
SIGN_WARN = $(STYLE_WARN) !$(STYLE_OFF)

# check for availability of Golang
ifeq ($(shell which go >/dev/null 2>&1; echo $$?), 1)
	GO_AVAILABLE = false
else
	GO_AVAILABLE = true
	GO_PATH = $(shell which go)
	GO_VERSION = $(shell go version | grep -m 1 -o '[0-9]*\.[0-9]*\.[0-9]')
endif
# end: check for availability of Golang

# check for availability of Ruby
# Version must be higher than 2.1 for awsspec.
# Hold my beer. This ain't gonna be pretty. https://dcmnt.me/2kuR8lR
RUBY_PATH = $(shell which ruby)
RUBY_VERSION = $(shell ruby --version | grep -m 1 -o '[0-9]*\.[0-9]*\.[0-9]')
RUBY_VER_MAJOR := $(shell echo $(RUBY_VERSION) | cut -f1 -d.)
RUBY_VER_MINOR := $(shell echo $(RUBY_VERSION) | cut -f2 -d.)
RUBY_GT_2_1 := $(shell [ $(RUBY_VER_MAJOR) -gt 2 -o \( $(RUBY_VER_MAJOR) -eq 2 -a $(RUBY_VER_MINOR) -ge 1 \) ] && echo true)

ifeq ($(RUBY_GT_2_1),true)
	RUBY_AVAILABLE = true
else
	RUBY_AVAILABLE = false
endif
# end: check for availability of Ruby

# check for availability of Packer
ifeq ($(shell which packer >/dev/null 2>&1; echo $$?), 1)
	PACKER_AVAILABLE = false
else
	PACKER_AVAILABLE = true
	PACKER_PATH = $(shell which packer)
	PACKER_VERSION = $(shell packer version | grep -m 1 -o '[0-9]*\.[0-9]*\.[0-9]')
endif
# end: check for availability of Packer

# check for availability of AWS CLI
ifeq ($(shell which aws >/dev/null 2>&1; echo $$?), 1)
	AWSCLI_AVAILABLE = false
else
	AWSCLI_AVAILABLE = true
	AWSCLI_PATH = $(shell which aws)
endif
# end: check for availability of AWS CLI


###
 # Targets
###
.PHONY: help
help:
	@echo
	@echo "$(STYLE_BRIGHT)"
	@echo " _______   _____    _____        __                     ____    _____     _____ "
	@echo "|__   __| |  __ \  |  __ \      / _|                   / __ \  |  __ \   / ____|"
	@echo "   | |    | |  | | | |  | |    | |_    ___    _ __    | |  | | | |__) | | (___  "
	@echo "   | |    | |  | | | |  | |    |  _|  / _ \  | '__|   | |  | | |  ___/   \___ \ "
	@echo "   | |    | |__| | | |__| |    | |   | (_) | | |      | |__| | | |       ____) |"
	@echo "   |_|    |_____/  |_____/     |_|    \___/  |_|       \____/  |_|      |_____/ "
	@echo ""
	@echo "  $(STYLE_MUTE)CfgMgmtCamp 2017 Ghent edition$(STYLE_MUTE) "
	@echo "$(STYLE_MUTE)"
	@echo
	@echo	"$(STYLE_BRIGHT)   Targets:$(STYLE_OFF)"
	@echo "     make check $(STYLE_MUTE)..................$(STYLE_OFF) checks if all required dependencies are installed"
	@echo "     make install-bundler $(STYLE_MUTE)........$(STYLE_OFF) installs Bundler via Gem"
	@echo "     make install-rspec $(STYLE_MUTE)..........$(STYLE_OFF) installs RSpec via Gem"
	@echo "     make install-rspec-deps $(STYLE_MUTE).....$(STYLE_OFF) installs ServerSpec, A via Gem"
	@echo

.PHONY: check
check:
	@echo
	@echo "Checking local dependencies..."

# BEGIN: check for `packer` availability
	@echo
	@echo "Packer"

ifeq ($(PACKER_AVAILABLE), true)
	@echo "$(SIGN_OK) found binary at \"$(PACKER_PATH)\""
	@echo "$(SIGN_OK) found version \"$(PACKER_VERSION)\""
else
	@echo "$(SIGN_ERR) unable to find \"packer\""
	@EXIT_WITH_ERROR = true
endif
# END: check for `packer` availability

# BEGIN: check for `ruby` availability
	@echo
	@echo "Ruby"

ifeq ($(RUBY_AVAILABLE), true)
	@echo "$(SIGN_OK) found binary at \"$(RUBY_PATH)\""
	@echo "$(SIGN_OK) found version \"$(RUBY_VERSION)\""
else
	@echo "$(SIGN_ERR) unable to find \"ruby\""
	@EXIT_WITH_ERROR = true
endif
# END: check for `ruby` availability

# BEGIN: check for `aws` availability
	@echo
	@echo "AWS CLI"

ifeq ($(AWSCLI_AVAILABLE), true)
	@echo "$(SIGN_OK) found binary at \"$(AWSCLI_PATH)\""
else
	@echo "$(SIGN_ERR) unable to find \"aws\""
	@EXIT_WITH_ERROR = true
endif
# END: check for `aws` availability

	@echo

ifeq ($(EXIT_WITH_ERROR), true)
	exit 1
endif


.PHONY: install-bundler
install-bundler:
	@echo "$(STYLE_BRIGHT)Going to install Bundler using Gem.$(STYLE_OFF)" && \
  echo "$(STYLE_MUTE)Any output that follows is from \`gem\`:$(STYLE_OFF)\n" && \
  echo && \
	gem \
		install \
      bundler

.PHONY: install-rspec
install-rspec:
	@echo "$(STYLE_BRIGHT)Going to install RSpec using Gem.$(STYLE_OFF)" && \
  echo "$(STYLE_MUTE)Any output that follows is from \`gem\`:$(STYLE_OFF)\n" && \
  echo && \
	gem \
		install \
      rspec

.PHONY: install-rspec-deps
install-rspec-deps:
	@echo "$(STYLE_BRIGHT)Going to install RSpec dependenies.$(STYLE_OFF)" && \
  echo "$(STYLE_MUTE)Any output that follows is from \`bundle\`:$(STYLE_OFF)\n" && \
  echo && \
  bundle \
    install


.PHONY: install-packer-deps
install-packer-deps:
	@echo "$(STYLE_BRIGHT)Going to install Packer dependencies.$(STYLE_OFF)" && \
  echo "$(STYLE_MUTE)Any output that follows is from \`go\`:$(STYLE_OFF)\n" && \
  echo "" && \
	gem \
		install rspec

.PHONY: step-1
step-1:
	@echo "$(STYLE_BRIGHT)STEP 1:$(STYLE_OFF)" && \
  echo "$(STYLE_MUTE)Building testable image using Packer:$(STYLE_OFF)" && \
  echo && \
  cd "1-packer" && \
  packer \
    build \
      "image.json"

.PHONY: step-2
step-2:
	@echo "$(STYLE_BRIGHT)STEP 2:$(STYLE_OFF)" && \
  echo "$(STYLE_MUTE)Building testable image using Docker:$(STYLE_OFF)" && \
  echo && \
  cd "2-docker" && \
  make \
    build && \
  make \
    test
