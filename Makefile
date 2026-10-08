SHELL = /bin/sh

.DEFAULT_GOAL:=help

##@ DBT
.PHONY: deps
deps: ## Launch dbt deps command.
	dbt deps

.PHONY: docs/generate
docs/generate: ## Generate DBT docs
	@dbt docs generate --exclude tag:unit-test

.PHONY: docs/serve
docs/serve: ## Serve DBT docs with web server
	@dbt docs serve --port 8000 --no-browser || true

.PHONY: test/scripts
test/scripts: ## Run unit tests
	@cd scripts/dbt/ && ./tests/run_all.sh

.PHONY: test/unit
test/unit: ## Run unit tests
	@dbt test -s tag:unit-test

.PHONY: test/data-quality
test/data-quality: ## Run all data quality tests (excluding unit tests).
	dbt test -s tests/* --exclude tag:unit-test

##@ Docker
.PHONY: docker/build
docker/build: deps ## Build image
	@docker build -t revenues-ccy .

.PHONY: docker/run
docker/run:  ## Run image interactively
	@docker run --env-file .env -it revenues-ccy /bin/bash

##@ Others
.PHONY: shell
shell: ## Activate poetry shell.
	poetry shell

.PHONY: install
install: ## Install dependencies using poetry.
	poetry install

.PHONY: lint
lint: ## Lint SQL with sqlfluff.
	sqlfluff lintcurrent-dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
dbt_project = `grep -e "^name:" dbt_project.yml | sed -e 's/^.*: //' -e 's/"//g' -e "s/'//g"`

.PHONY: mkdocs
mkdocs: ## Generate mkdocs docs from specify model. -> make mkdocs model='mymodel'
	@echo "\n🛠️  Generating mkdocs from manifest.json...\n"
	@./dbt_packages/dbt_commons/generate_docs/generate_docs.sh $(current-dir) $(dbt_project) $(dbt_project).$(model) $(dbt_project).$(dbt_project).$(model)
	@echo "\n📑  Mkdocs documentation created.\n"

.PHONY: help
help: ## Show help
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} /^[a-z \/A-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
