.DEFAULT_GOAL := help

.PHONY: help
help:
	@echo "List of available make commands";
	@echo "";
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}';
	@echo "";

# ci
.PHONY: ci
ci: build analyze format

# analyze
.PHONY: analyze
analyze: ## Analyze all apps with Flutter
	fvm dart analyze .

# format
.PHONY: format
format: ## Format all code
	fvm dart format .
	npx prettier --write "**/*.md"

# run build
.PHONY: build
build: ## Same functionality as `fvm dart run build_runner build` (made available at root level) Usage: `make build`
	fvm dart run build_runner build --delete-conflicting-outputs

.PHONY: pub_get
pub_get: ## Run pub get: `make pub_get`
	fvm dart pub get

.PHONY: pub_publish_dry_run
pub_publish_dry_run: ## Dry run for pub publish: `make pub_publish_dry_run`
	fvm dart pub publish --dry-run

.PHONY: pub_publish
pub_publish: ## Publish to pub.dev: `make pub_publish`
	fvm dart pub publish

.PHONY: add_dependency
add_dependency: ## Add a dependency to the package: `make add_dependency <dependency_name>`
	if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "\033[0;31mPlease provide a dependency name."; \
	else \
		fvm dart pub add $(filter-out $@,$(MAKECMDGOALS)); \
	fi

%:
	@:
