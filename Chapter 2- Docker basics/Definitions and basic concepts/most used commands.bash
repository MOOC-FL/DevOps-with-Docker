Here are the most commonly used Docker commands:

## **Container Management**
```bash
# List running containers
docker ps

# List all containers (including stopped)
docker ps -a

# Run a container
docker run [options] image_name

# Stop a container
docker stop container_name

# Start a stopped container
docker start container_name

# Remove a container
docker rm container_name

# Remove a running container (force)
docker rm -f container_name

# View container logs
docker logs container_name

# Follow logs in real-time
docker logs -f container_name

# Execute command in running container
docker exec -it container_name bash
```

## **Image Management**
```bash
# List images
docker images

# Pull an image
docker pull image_name

# Remove an image
docker rmi image_name

# Remove unused images
docker image prune

# Build an image from Dockerfile
docker build -t image_name .
```

## **Common Run Options**
```bash
# Run with port mapping
docker run -p 8080:80 image_name

# Run in background (detached)
docker run -d image_name

# Run with name
docker run --name mycontainer image_name

# Run with volume mounting
docker run -v /host/path:/container/path image_name

# Run with environment variables
docker run -e VAR_NAME=value image_name

# Run interactive with TTY
docker run -it image_name bash
```

## **System & Maintenance**
```bash
# Check Docker version
docker --version

# Show disk usage
docker system df

# Remove unused data
docker system prune

# Remove everything (containers, images, volumes)
docker system prune -a

# Check Docker info
docker info
```

## **Network Management**
```bash
# List networks
docker network ls

# Inspect a network
docker network inspect network_name

# Create a network
docker network create network_name

# Connect container to network
docker network connect network_name container_name
```

## **Docker Compose** (if installed)
```bash
# Start services
docker-compose up

# Start in background
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs

# List services
docker-compose ps
```

## **Most Common Workflow Examples**
```bash
# Typical workflow
docker pull nginx:latest
docker run -d --name my-nginx -p 8080:80 nginx
docker ps
docker logs my-nginx
docker exec -it my-nginx bash
docker stop my-nginx
docker rm my-nginx
docker rmi nginx
```

- `docker ps`
- `docker run`
- `docker stop`
- `docker rm`
- `docker logs`
- `docker exec`
