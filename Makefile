start:
	docker start spigot-server
	docker exec "/opt/minecraft-server/start.sh"

stop:
	docker exec "screen -ls | grep Detached | cut -d. -f1 | awk '{print $1}' | xargs kill"
	docker stop spigot-server