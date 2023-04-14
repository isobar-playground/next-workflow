include .env
-include .env.local

default: up

## help	:	Print commands help.
.PHONY: help
help : Makefile
	@sed -n 's/^##//p' $<

## up	:	Start up containers.
up:
	@echo "Starting up containers for $(PROJECT_NAME)..."
	@touch -a .env.local
	docker-compose --env-file .env --env-file .env.local pull
	docker-compose --env-file .env --env-file .env.local up -d --remove-orphans
	@git config core.hooksPath .hooks

## build	:	Build containers and install npm dependencies.
build:
	@docker-compose --env-file .env --env-file .env.local build --no-cache nextjs

## shell	:	Access `nextjs` container via shell.
##		You can optionally pass an argument with a service name to open a shell on the specified container
.PHONY: shell
shell:
	docker exec -ti -e COLUMNS=$(shell tput cols) -e LINES=$(shell tput lines) $(shell docker ps --filter name='$(PROJECT_NAME)_$(or $(filter-out $@,$(MAKECMDGOALS)), 'nextjs')' --format "{{ .ID }}") sh

## logs	:	View containers logs.
##		You can optinally pass an argument with the service name to limit logs
##		logs nextjs	: View `nextjs` container logs.
.PHONY: logs
logs:
	echo $(filter-out $@,$(MAKECMDGOALS))
	@docker-compose --env-file .env --env-file .env.local logs -f $(filter-out $@,$(MAKECMDGOALS))

## rebuild	:	Rebuild container and start again.
rebuild: build up

## deploy-code-staging	:	Deploy code and build staging environment.
.PHONY: deploy-code-staging
deploy-code-staging:
	@echo "Get changes from master branch."
	@ssh ${SSH_HOST} "cd ${SSH_STAGING_PROJECT_ROOT} && git pull --rebase"
	@echo "Build and start container."
	@ssh ${SSH_HOST} "cd ${SSH_STAGING_PROJECT_ROOT} && make rebuild"
	@echo "Warm frontpage cache."
	@curl -s https://staging-next.iso-playground.ovh/
	@echo "Done."

## deploy-code-production	:	Deploy code and build staging environment.
.PHONY: deploy-code-production
deploy-code-production:
	@echo "Get changes from master branch."
	@ssh ${SSH_HOST} "cd ${SSH_PRODUCTION_PROJECT_ROOT} && git pull --rebase"
	@echo "Build and start container."
	@ssh ${SSH_HOST} "cd ${SSH_PRODUCTION_PROJECT_ROOT} && make rebuild"
	@echo "Warm frontpage cache."
	@curl -s https://production-next.iso-playground.ovh/
	@echo "Done."
