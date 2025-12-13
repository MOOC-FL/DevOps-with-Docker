#### Allowing external connections into containers​
- This course does not provide an in-depth exploration of inter-program communication mechanisms. If you want to learn that in-depth, you should look at classes about Operating Systems or Networking. Here, you just need to know a few simple things:
  - Sending messages: Programs can send messages to URL(opens in a new tab)(opens in a new tab) addresses such as this: http://127.0.0.1:3000(opens in a new tab)(opens in a new tab) where HTTP is the protocol(opens in a new tab)(opens in a new tab), 127.0.0.1 is an IP address, and 3000 is a port(opens in a new tab)(opens in a new tab). Note the IP part could also be a hostname(opens in a new tab)(opens in a new tab): 127.0.0.1 is also called localhost(opens in a new tab)(opens in a new tab) so instead you could use http://localhost:3000.
  -  Receiving messages: Programs can be assigned to listen to any available port. If a program is listening for traffic on port 3000, and a message is sent to that port, the program will receive and possibly process it.

- The address 127.0.0.1 and hostname localhost are special ones, they refer to the machine or container itself, so if you are on a container and send a message to localhost, the target is the same container. Similarly, if you are sending the request from outside of a container to localhost, the target is your machine.
- It is possible to map a port on your host machine to a container port. For example, if you map port 1000 on your host machine to port 2000 in the container, and then send a message to http://localhost:1000 on your computer, the container will receive that message if it's listening to its port 2000.
- Opening a connection from the outside world to a Docker container happens in two steps:
  - Exposing port
  - Publishing port

- Exposing a container port means informing Docker that the container listens to a certain port. This doesn't do much, except it helps humans with the configuration.
- Publishing a port means that Docker will map host ports to the container ports.
> To expose a port, add the line `EXPOSE <port>` in your Dockerfile
> To publish a port, run the container with `-p <host-port>:<container-port>`

- If you leave out the host port and only specify the container port, Docker will automatically choose a free port as the host port:
```bash
$ docker run -p 4567 app-in-port
```
- We could also limit connections to a certain protocol only, e.g. UDP by adding the protocol at the end: `EXPOSE <port>/udp` and `-p <host-port>:<container-port>/udp.`
> **Security reminder: Opening a door to the internet**
> Since we are opening a port to the application, anyone from the internet could come in and access what you're running.
> Don't haphazardly open just any ports - a way for an attacker to get in is by exploiting a port you opened to an insecure server. An easy way to avoid this is by defining the host-side port like this -p 127.0.0.1:3456:3000. This will only allow requests from your computer through port 3456 to the application port 3000, with no outside access allowed.
> The short syntax, `-p 3456:3000,` will result in the same as `-p 0.0.0.0:3456:3000,` which truly is opening the port to everyone.
> Usually, this isn't risky. But depending on the application, it is something you should consider!














