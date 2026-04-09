build:
	clear
	docker compose up --build && mv src/B .
 
clean:
	docker compose down
