.PHONY: help up down restart stop ps logs bootstrap

COMPOSE_FILES := -f docker-compose.yml -f docker-compose.app.yml -f docker-compose.npm.yml
COMPOSE_CMD := $(shell if docker compose version >/dev/null 2>&1; then printf 'docker compose'; elif command -v docker-compose >/dev/null 2>&1; then printf 'docker-compose'; else printf 'docker compose'; fi)
COMPOSE := $(COMPOSE_CMD) $(COMPOSE_FILES)
WIPE_DIRS := volumes/db/data volumes/storage/stub volumes/daiana volumes/qdrant
WIPE ?= 0

.DEFAULT_GOAL := help

help:
	@echo "╔════════════════════════════════════════════════════════════╗"
	@echo "║          Comandos disponibles                              ║"
	@echo "╚════════════════════════════════════════════════════════════╝"
	@echo ""
	@echo "Stack completo:"
	@echo "  make up                      Levanta Docker Compose"
	@echo "  make up WIPE=1               Levanta Docker Compose y limpia volúmenes"
	@echo "                  - Si está corriendo, lo baja primero"
	@echo "                  - Limpia: db/data, storage/stub, daiana, qdrant"
	@echo "  make down                    Baja Docker Compose"
	@echo "  make down WIPE=1             Baja Docker Compose y limpia volúmenes"
	@echo "  make ps                      Muestra el estado del stack"
	@echo "  make logs                    Muestra logs de todo el stack"
	@echo ""
	@echo "Servicio individual:"
	@echo "  make up SERVICE=<servicio>      Levanta un servicio"
	@echo "  make restart SERVICE=<servicio> Reinicia un servicio"
	@echo "  make stop SERVICE=<servicio>    Detiene un servicio"
	@echo "  make down SERVICE=<servicio>    Baja y elimina un servicio"
	@echo "  make ps SERVICE=<servicio>      Muestra el estado de un servicio"
	@echo "  make logs SERVICE=<servicio>    Muestra logs de un servicio"
	@echo ""
	@echo "  make bootstrap  Ejecuta npm_ssl_bootstrap"
	@echo "                  - Configura SSL para npm"
	@echo ""
	@echo "  make help       Muestra esta información"
	@echo ""

up:
	@if [ -n "$(SERVICE)" ]; then \
		if [ "$(WIPE)" = "1" ]; then \
			echo "⚠️  WIPE=1 se ignora cuando SERVICE está definido"; \
		fi; \
		echo "Levantando servicio $(SERVICE)..."; \
		$(COMPOSE) up -d "$(SERVICE)"; \
		echo "✓ Servicio $(SERVICE) levantado"; \
	else \
		if [ "$(WIPE)" = "1" ]; then \
			if $(COMPOSE) ps 2>/dev/null | grep -q "Up"; then \
				echo "Docker Compose está ejecutándose. Bajando..."; \
				$(COMPOSE) down; \
			fi; \
			echo "Limpiando volúmenes..."; \
			rm -rf $(WIPE_DIRS); \
		fi; \
		echo "Levantando Docker Compose..."; \
		$(COMPOSE) up -d; \
		echo "✓ Docker Compose levantado"; \
	fi

down:
	@if [ -n "$(SERVICE)" ]; then \
		if [ "$(WIPE)" = "1" ]; then \
			echo "⚠️  WIPE=1 se ignora cuando SERVICE está definido"; \
		fi; \
		echo "Bajando servicio $(SERVICE)..."; \
		$(COMPOSE) stop "$(SERVICE)"; \
		$(COMPOSE) rm -f "$(SERVICE)"; \
	else \
		echo "Bajando Docker Compose..."; \
		$(COMPOSE) down; \
	fi
	@if [ "$(WIPE)" = "1" ]; then \
		echo "Limpiando volúmenes..."; \
		rm -rf $(WIPE_DIRS); \
	fi
	@echo "✓ Docker Compose bajado"

restart:
	@if [ -n "$(SERVICE)" ]; then \
		echo "Reiniciando servicio $(SERVICE)..."; \
		$(COMPOSE) restart "$(SERVICE)"; \
	else \
		echo "Reiniciando Docker Compose..."; \
		$(COMPOSE) restart; \
	fi
	@echo "✓ Docker Compose reiniciado"

stop:
	@if [ -n "$(SERVICE)" ]; then \
		echo "Deteniendo servicio $(SERVICE)..."; \
		$(COMPOSE) stop "$(SERVICE)"; \
	else \
		echo "Deteniendo Docker Compose..."; \
		$(COMPOSE) stop; \
	fi
	@echo "✓ Docker Compose detenido"

ps:
	@if [ -n "$(SERVICE)" ]; then \
		$(COMPOSE) ps "$(SERVICE)"; \
	else \
		$(COMPOSE) ps; \
	fi

logs:
	@if [ -n "$(SERVICE)" ]; then \
		$(COMPOSE) logs -f "$(SERVICE)"; \
	else \
		$(COMPOSE) logs -f; \
	fi

bootstrap:
	@if [ ! -f .env ]; then \
		echo "❌ .env no encontrado"; \
		exit 1; \
	fi
	@echo "Cargando variables de .env..."
	@set -a; . .env; set +a; \
	if [ -z "$$NPM_ADMIN_EMAIL" ] || [ -z "$$NPM_ADMIN_PASS" ]; then \
		echo "❌ Faltan variables requeridas en .env:"; \
		[ -z "$$NPM_ADMIN_EMAIL" ] && echo "  - NPM_ADMIN_EMAIL"; \
		[ -z "$$NPM_ADMIN_PASS" ] && echo "  - NPM_ADMIN_PASS"; \
		exit 1; \
	fi; \
	echo "✓ Variables cargadas:"; \
	echo "  - NPM_ADMIN_EMAIL: $$NPM_ADMIN_EMAIL"; \
	echo "  - NPM_ADMIN_PASS: (configurado)"; \
	[ -n "$$BASE_DOMAIN" ] && echo "  - BASE_DOMAIN: $$BASE_DOMAIN"; \
	echo ""; \
	echo "Ejecutando npm_ssl_bootstrap..."; \
	bash utils/npm_ssl_bootstrap.sh; \
	echo "✓ Bootstrap completado"
