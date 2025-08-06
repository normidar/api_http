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

# add_freezed: https://pub.dev/packages/freezed#install
.PHONY: add_freezed
add_freezed: ## Add freezed to package: `make add_freezed pkg/my_pkg`
	if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "\033[0;31mPlease provide a path for the package"; \
	else \
		$(DART_CMD) pub add freezed_annotation && \
		$(DART_CMD) pub add dev:build_runner && \
		$(DART_CMD) pub add dev:freezed && \
		$(DART_CMD) pub add json_annotation && \
		$(DART_CMD) pub add dev:json_serializable; \
	fi

# git branch clean
.PHONY: git_branch_clean
git_branch_clean: ## Delete local branches that don't exist on remote
	chmod u+x sh_scripts/git_branch_clean.sh && \
	./sh_scripts/git_branch_clean.sh

# git_create_tag
.PHONY: git_create_tag
git_create_tag: ## Create a tag: `make git_create_tag <tag_name>`
	if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "\033[0;31mPlease provide a tag name."; \
	else \
		git tag $(filter-out $@,$(MAKECMDGOALS)) && \
		git push origin $(filter-out $@,$(MAKECMDGOALS)); \
	fi

# git_my_tasks
.PHONY: git_my_tasks
git_my_tasks: ## Display my tasks: `make git_my_tasks apps/app_name`
	if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		gh issue ls --assignee @me; \
	else \
		gh issue ls --assignee @me --search 'label:$(shell basename $(filter-out $@,$(MAKECMDGOALS)))'; \
	fi

.PHONY: pub_publish_dry_run
pub_publish_dry_run: ## Dry run for pub publish: `make pub_publish_dry_run`
	fvm dart pub publish --dry-run

.PHONY: add_dependency
add_dependency: ## Add a dependency to the package: `make add_dependency <dependency_name>`
	if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "\033[0;31mPlease provide a dependency name."; \
	else \
		fvm dart pub add $(filter-out $@,$(MAKECMDGOALS)); \
	fi

%:
	@: