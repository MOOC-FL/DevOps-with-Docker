#### Interacting with the container via volumes and ports
- Let us get back to yt-dlp. It works yes, but it is quite laborious to get the downloaded videos to the host machine.
- There are two ways to achieve this. We can use Docker volumes(opens in a new tab)(opens in a new tab) to make it easier to store the downloads outside the container's ephemeral storage. With bind mount(opens in a new tab)(opens in a new tab) we can mount a file or directory from our own machine (the host machine) into the container.
- Let's start a container with the `-v ` option. Prior to Docker Engine version 23, this option required an absolute path. However, as of Docker Engine version 23, you can use the `-v` option with relative paths on the host. We mount our current folder as `/mydir` in the container, overwriting everything that we have put in that folder in our Dockerfile.
```bash
$ docker run -v "$(pwd):/mydir" yt-dlp https://www.youtube.com/watch?v=saEpkcVi1d4
```
- Now the downloaded video is saved to the working directory in the host machine, nice!
- A Docker volume is essentially a shared directory or file between the host machine and the container. When a program running inside the container modifies a file within this volume, the changes are preserved even after the container is shut down and removed, as the file resides on the host machine. This is the primary advantage of using volumes; without them, any files created or modified within the container would be lost upon recreating it again from the image. Additionally, volumes facilitate file sharing between containers, enabling programs to access and load updated files seamlessly.

- In our `yt-dlp` container we wanted to mount the whole directory since the files are fairly randomly named. If we wish to create a volume with only a single file we could also do that by pointing to it. For example -v "$(pwd)/material.md:/mydir/material.md" this way we could edit the file material.md locally and have it change in the container (and vice versa).
> Note also that the -v option creates a directory if the specific file does not exist.

