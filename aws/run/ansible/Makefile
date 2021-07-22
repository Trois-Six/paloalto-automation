.PHONY: help all run delete check install
.DEFAULT_GOAL := all

REQUIRED_BINS := ansible-playbook pip ansible-galaxy
$(foreach bin,$(REQUIRED_BINS),\
    $(if $(shell command -v $(bin) 2> /dev/null),,$(error Please install `$(bin)`)))

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

all: run
run: ## Launch playbook - create all
	ansible-playbook -i inventory.yml -e "project_state=present" site.yml

delete: ## Launch playbook - delete all
	ansible-playbook -i inventory.yml -e "project_state=absent" site.yml

check: ## Launch playbook - dry run
	ansible-playbook -i inventory.yml site.yml --check

install:
	pip install pan-python pan-os-python
	ansible-galaxy install -r requirements.yml
