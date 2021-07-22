.PHONY: build
.DEFAULT_GOAL := build

REQUIRED_BINS := go
$(foreach bin,$(REQUIRED_BINS),\
    $(if $(shell command -v $(bin) 2> /dev/null),,$(error Please install `$(bin)`)))

build:
	@echo "Building firewall-commit binary...\n"
	@go build 
