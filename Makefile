.DEFAULT_GOAL := all

define BROWSER_PYSCRIPT
import os, webbrowser, sys

from urllib.request import pathname2url

webbrowser.open("file://" + pathname2url(os.path.abspath(sys.argv[1])))
endef
export BROWSER_PYSCRIPT

define PRINT_HELP_PYSCRIPT
import re, sys

for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		print("%-20s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT

BROWSER := python -c "$$BROWSER_PYSCRIPT"

ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(ARGS):;@:)

.PHONY: help
help: ## Print this help message
	@python -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)

ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(ARGS):;@:)

.PHONY: all
all:
	opam exec -- dune build --root . @install

.PHONY: deps
deps: ## Install development dependencies
	opam pin add -y --no-action rock.~dev https://github.com/rgrinberg/opium.git
	opam pin add -y --no-action opium.~dev https://github.com/rgrinberg/opium.git
	opam pin add -y --no-action opium-testing.~dev https://github.com/rgrinberg/opium.git
	opam pin add -y --no-action lwd.~dev https://github.com/let-def/lwd.git
	opam pin add -y --no-action tyxml-lwd.~dev https://github.com/let-def/lwd.git#tyxml-scheduler
	opam install --locked --deps-only --with-test --with-doc -y .
	opam install -y merlin ocamlformat utop ocaml-lsp-server
	npm install

.PHONY: switch
switch: ## Create an opam switch and install development dependencies
	opam update
	[[ $(shell opam switch show) == $(shell pwd) ]] || \
		opam switch create -y . 4.11.0 --no-install
	opam install . -y --deps-only --with-doc --with-test --locked
	opam install -y merlin ocamlformat utop ocaml-lsp-server omigrate
	npm install

.PHONY: lock
lock: ## Generate a lock file
	opam lock -y .

.PHONY: build
build: ## Build the project, including non installable libraries and executables
	opam exec -- dune build --root .

.PHONY: release
release: clean ## Build a production build
	NODE_ENV=production opam exec -- dune build --root . --profile=release

.PHONY: install
install: all ## Install the packages on the system
	opam exec -- dune install --root .

.PHONY: start
start: build ## Run the produced executable
	opam exec -- dune exec bin/server.exe -- $(ARGS)

.PHONY: start
start-watch: all ## Run the produced executable
	opam exec -- ./script/start-watch.sh $(ARGS)

.PHONY: migrate
migrate: ## Run database migrations
	OMIGRATE_DATABASE=postgres://localhost:5432/sapiens_dev \
	OMIGRATE_SOURCE=./migration \
	opam exec -- omigrate $(ARGS) -vv

.PHONY: migrate
migrate-test: ## Run database migrations for the test environment
	OMIGRATE_DATABASE=postgres://localhost:5432/sapiens_test \
	OMIGRATE_SOURCE=./migration \
	opam exec -- omigrate $(ARGS) -vv

.PHONY: test
test: ## Run the unit tests
	SAPIENS_ENV=test opam exec -- dune build --root . @test/runtest -j 1 -- $(ARGS)

.PHONY: clean
clean: ## Clean build artifacts and other generated files
	opam exec -- dune clean --root .

.PHONY: doc
doc: ## Generate odoc documentation
	opam exec -- dune build --root . @doc

.PHONY: servedoc
servedoc: doc ## Open odoc documentation with default web browser
	$(BROWSER) _build/default/_doc/_html/index.html

.PHONY: fmt
fmt: ## Format the codebase with ocamlformat
	opam exec -- dune build --root . --auto-promote @fmt

.PHONY: watch
watch: ## Watch for the filesystem and rebuild on every change
	opam exec -- dune build --root . --watch

.PHONY: utop
utop: ## Run a REPL and link with the project's libraries
	opam exec -- dune utop --root . lib -- -implicit-bindings
