include .env
export

env-up:
	@docker compose up -d wishlist-postgres

env-down:
	@docker compose down wishlist-postgres

env-cleanup:
	@read -p "Clear all volume env files? [y/N]: " ans; \
	if [ "$$ans" = "y" ]; then \
		docker compose down wishlist-postgres && \
		rm -fr out/pgdata && \
		echo "Cleared"; \
	else \
		echo "Not cleared"; \
	fi

migrate-create:
	@if [ -z "$(seq)" ]; then \
		echo "No value in var seq"; \
		exit 1; \
	fi; \

	@docker compose run --rm wishlist-postgres-migrate \
		create \
		-ext sql \
		-dir /migrations \
		-seq "$(seq)"

migrate-up:
	@make migrate-action action=up

migrate-down:
	@make migrate-action action=down

migrate-action:
	@if [ -z "$(action)" ]; then \
		echo "No value in var action"; \
		exit 1; \
	fi; \

	@docker compose run --rm wishlist-postgres-migrate \
		-path /migrations \
		-database postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@wishlist-postgres:5432/${POSTGRES_DB}?sslmode=disable \
		$(action)

docker-build:
	docker-compose up --build
