- Images are the basic building blocks for containers and other images. When you "containerize" an application you work towards creating the image.

- By learning what images are and how to create them, you'll be ready to start utilizing containers in your own projects.

#### Where do the images come from?​
- When running a command such as `docker run hello-world`, Docker will automatically search Docker Hub
 for the image if it is not found locally.
- This means that we can pull and run any public image from Docker's servers. For example‚ if we wanted to start an instance of the PostgreSQL database, we could just `run docker run postgres`, which would pull and run https://hub.docker.com/_/postgres/
  - We can search for images in the Docker Hub with `docker search`. Try running `docker search hello-world.`
- The search finds plenty of results, and prints each image's name, short description, amount of stars, and "official" status.


