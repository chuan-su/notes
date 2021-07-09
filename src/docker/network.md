# network

## You don't need `docker-compose`

`docker-compose` by default creates a `bridge` docker network named `<directory>_default` for connecting docker containers. To specify different network name:

```yaml
version: "3.3"
services:
  web:
    image: registry/image_name:version
    container_name: web
    networks:
      - skywalker 	

  postgres:
    image: registry/image_name:version
    container_name: postgres
    networks:
      - skywalker 	
  
networks:
  skywalker:
    driver: bridge  	
```

This will create a `bridge` docker network named `skywalker_docker`.

The reason why the containers are interconnected is that they share the same `docker bridged network`. The `docker-compose` yaml scripts can be easily rewritten using `docker network`.

```bash
docker network create -d bridge skywalker

docker run -d --rm --network skywalker --name web registry/image_name:version
docker run -d --rm --network skywalker --name postgres registry/image_name:version
```

And the `web` container can communicate the `postgres` container through `postgres:5432`.

**Note:** The `container_name` is the host inside the docker network.

To inspect the network:

```bash
docker network inspect skywalker
```
Other useful commands can be found at [https://docs.docker.com/engine/reference/commandline/network/](https://docs.docker.com/engine/reference/commandline/network/).
