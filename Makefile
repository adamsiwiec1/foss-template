.PHONY: help docs docs-build check bootstrap-packaging

help:
	@echo "docs                   VitePress dev server"
	@echo "docs-build             Production docs build (CI / Pages)"
	@echo "check                  Same as docs-build"
	@echo "bootstrap-packaging    Create brew/scoop/apt/choco companion repos"
	@echo "                       Usage: make bootstrap-packaging OWNER=you"

docs:
	npm run docs:dev

docs-build:
	npm run docs:build

check: docs-build

bootstrap-packaging:
	@test -n "$(OWNER)" || (echo "usage: make bootstrap-packaging OWNER=your-github-user" >&2; exit 1)
	./scripts/bootstrap-packaging.sh --owner "$(OWNER)" --yes $(ARGS)