.PHONY: help docs docs-build check

help:
	@echo "docs         VitePress dev server"
	@echo "docs-build   Production docs build (CI / Pages)"
	@echo "check        Same as docs-build"

docs:
	npm run docs:dev

docs-build:
	npm run docs:build

check: docs-build
