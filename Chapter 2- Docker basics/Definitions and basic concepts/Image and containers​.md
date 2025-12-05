#### Image and containers​
- Since we already know what containers are it's easier to explain images through them: Containers are instances of images. A basic mistake is to confuse images and containers.
> Think of a container as a ready-to-eat meal that you can simply heat up and consume. An image, on the other hand, is the recipe and the ingredients for that meal.

- So just like how you need a recipe and ingredients to make a meal, you need an image and a container runtime (Docker engine) to create a container. The image provides all the necessary instructions and dependencies for the container to run, just like a recipe provides the steps and ingredients to make a meal.
- In short, an image is like a blueprint or template and the building material, while a container is an instance of that blueprint or template.
#### image
- A Docker image is a file. An image never changes; you can not edit an existing file. Creating a new image happens by starting from a base image and adding new layers to it. We will talk about layers later, but you should think of images as immutable, they can not be changed after they are created.
```bash
$ docker image ls
  REPOSITORY      TAG      IMAGE ID       CREATED         SIZE
  hello-world     latest   d1165f221234   9 days ago      13.3kB
```
> Containers are created from images, so when we ran hello-world twice we downloaded one image and created two separate containers from the single image.
- Well then, if images are used to create containers, where do images come from? This image file is built from an instructional file named Dockerfile that is parsed when you run `docker image build`.
- Dockerfile is a file that is by default called Dockerfile, that looks something like this
```bash
FROM <image>:<tag>

RUN <install some dependencies>

CMD <command that is executed on `docker container run`>
```
- and is the instruction set for building an image. We will look into Dockerfiles later when we get to build our own images.

> If we go back to the cooking metaphor, as Dockerfile provides the instructions needed to build an image you can think of that as the recipe for images. We're now 2 recipes deep, as Dockerfile is the recipe for an image and an image is the recipe for a container. The only difference is that Dockerfile is written by us, whereas image is written by our machine based on the Dockerfile!

#### container
- Containers contain the application and what is required to execute it (dependencies); and you can start, stop and interact with them. They are isolated environments in the host machine with the ability to interact with each other and the host machine itself via defined methods (TCP/UDP).
> List all your containers with `docker container ls`
```bash
$ docker container ls
  CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```
> Without `-a `flag it will only print running containers. The hello-worlds we ran already exited.
```bash
$ docker container ls -a
  CONTAINER ID   IMAGE           COMMAND      CREATED          STATUS                      PORTS     NAMES
  b7a53260b513   hello-world     "/hello"     5 minutes ago    Exited (0) 5 minutes ago              brave_bhabha
  1cd4cb01482d   hello-world     "/hello"     8 minutes ago    Exited (0) 8 minutes ago              vibrant_bell
```
> The command `docker container ls` has also a shorter form `docker ps` that is preferred by many since it requires much less typing...






