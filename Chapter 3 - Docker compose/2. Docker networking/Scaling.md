#### Scaling
- Compose can also scale the service to run multiple instances:
```bash
$ docker compose up --scale whoami=3

  WARNING: The "whoami" service specifies a port on the host. If multiple containers for this service are created on a single host, the port will clash.

  Starting whoami_whoami_1 ... done
  Creating whoami_whoami_2 ... error
  Creating whoami_whoami_3 ... error
```
- The command fails due to a port clash, as each instance will attempt to bind to the same host port (8000).
- We can get around this by only specifying the container port. As mentioned in Chapter 2, when leaving the host port unspecified, Docker will automatically choose a free port.
- Update the ports definition in `docker-compose.yaml`:
```bash
ports:
  - 8000
```
- Then run the command again:
```bash
$ docker compose up --scale whoami=3
  Starting whoami_whoami_1 ... done
  Creating whoami_whoami_2 ... done
  Creating whoami_whoami_3 ... done
```
- All three instances are now running and listening on random host ports. We can use `docker compose port` to find out which ports the instances are bound to.
```bash
$ docker compose port --index 1 whoami 8000
  0.0.0.0:32770
$ docker compose port --index 2 whoami 8000
  0.0.0.0:32769
$ docker compose port --index 3 whoami 8000
  0.0.0.0:32768
```
- We can now curl from these ports:
```bash
$ curl 127.0.0.1:32769
  I'm 536e11304357

$ curl 127.0.0.1:32768
  I'm 1ae20cd990f7
```
> n a server environment you would often have a load balancer(opens in a new tab)(opens in a new tab) in front of the service. For containerized local environment (or a single server) one good solution is to use https://github.com/jwilder/nginx-proxy
-  Let's add the nginx-proxy to our compose file and remove the port bindings from the whoami service. We will mount docker.sock(opens in a new tab)(opens in a new tab) of our host machine (the socket that is used to communicate with the Docker Daemon(opens in a new tab)(opens in a new tab)) inside of the container in :ro read-only mode:
```bash
services:
  whoami:
    image: jwilder/whoami
  proxy:
    image: jwilder/nginx-proxy
    volumes:
      - /var/run/docker.sock:/tmp/docker.sock:ro
    ports:
      - 80:80
```
- Let test the configuration:
```bash
$ docker compose up -d --scale whoami=3
$ curl localhost:80
  <html>
  <head><title>503 Service Temporarily Unavailable</title></head>
  <body bgcolor="white">
  <center><h1>503 Service Temporarily Unavailable</h1></center>
  <hr><center>nginx/1.13.8</center>
  </body>
  </html>
```
- It is "working", but the Nginx just does not know which service we want. The `nginx-proxy` works with two environment variables: `VIRTUAL_HOST` and `VIRTUAL_PORT`. `VIRTUAL_PORT` is not needed if the service has `EXPOSE` in it's `Docker image`. We can see that `jwilder/whoami` sets it: https://github.com/jwilder/whoami/blob/master/Dockerfile#L9(opens in a new tab)(opens in a new tab)
  - The domain colasloth.com is configured so that all subdomains point to 127.0.0.1. More information about how this works can be found at colasloth.github.io(opens in a new tab)(opens in a new tab), but in brief it is a simple DNS "hack". Several other domains serving the same purpose exist, such as localtest.me, lvh.me, and vcap.me, to name a few. In any case, let's use colasloth.com here:
```bash
services:
  whoami:
    image: jwilder/whoami
    environment:
      - VIRTUAL_HOST=whoami.colasloth.com
  proxy:
    image: jwilder/nginx-proxy
    volumes:
      - /var/run/docker.sock:/tmp/docker.sock:ro
    ports:
      - 80:80
```
> Now the proxy works:
```bash
$ docker compose up -d --scale whoami=3
$ curl whoami.colasloth.com
  I'm f6f85f4848a8
$ curl whoami.colasloth.com
  I'm 740dc0de1954
```
> Let's add couple of more containers behind the same proxy. We can use the official `nginx` image to serve a simple static web page. We do not have to even build the container images, we can just mount the content to the image. Let's prepare some content for two services called "hello" and "world".
```bash
$ echo "hello" > hello.html
$ echo "world" > world.html
```
- Then add these services to the `docker-compose.yaml` file where you mount just the content as `index.html` in the default `nginx `path:
```bash
hello:
  image: nginx:1.19-alpine
  volumes:
    - ./hello.html:/usr/share/nginx/html/index.html:ro
  environment:
    - VIRTUAL_HOST=hello.colasloth.com
world:
  image: nginx:1.19-alpine
  volumes:
    - ./world.html:/usr/share/nginx/html/index.html:ro
  environment:
    - VIRTUAL_HOST=world.colasloth.com
```
- Now let's test:
```bash
$ docker compose up -d --scale whoami=3
$ curl hello.colasloth.com
  hello

$ curl world.colasloth.com
  world

$ curl whoami.colasloth.com
  I'm f6f85f4848a8

$ curl whoami.colasloth.com
  I'm 740dc0de1954
```
> Now we have a basic single-machine hosting setup up and running.

Test updating the hello.html without restarting the container, does it work?






