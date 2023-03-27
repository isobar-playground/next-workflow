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
	@docker-compose --env-file .env --env-file .env.local build nextjs
	@docker-compose --env-file .env --env-file .env.local run --rm nextjs npm ci

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
	@docker-compose --env-file .env --env-file .env.local logs -f $(filter-out $@,$(MAKECMDGOALS))