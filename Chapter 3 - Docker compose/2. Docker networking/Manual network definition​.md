#### Manual network definition​
- It is also possible to define the network manually in a Docker Compose file. A major benefit of a manual network definition is that it makes it easy to set up a configuration where containers defined in two different Docker Compose files share a network and can easily interact with each other.
- Let us now have a look how a network is defined in docker-compose.yaml:
```bash
services:
  db:
    image: postgres:13.2-alpine
    networks:
      - database-network <em># Name in this Docker Compose file</em>

networks:
  database-network: <em># Name in this Docker Compose file</em>
    name: database-network <em># Name that will be the actual name of the network</em>
```
- This defines a network called `database-network` which is created with `docker compose up` and removed with `docker compose down`.
- As can be seen, services are configured to use a network by adding `networks` into the definition of the service.
- Establishing a connection to an external network (that is, a network defined in another docker-compose.yaml, or by some other means) is done as follows:
```bash
services:
  db:
    image: backend-image
    networks:
      - database-network

networks:
  database-network:
    external:
      name: database-network <em># Must match the actual name of the network</em>
```
- By default all services are added to a network called `default`. The default network can be configured and this makes it possible to connect to an external network by default as well:
```java
services:
  db:
    image: backend-image

networks:
  default:
    external:
      name: database-network <em># Must match the actual name of the network</em>
``` 




