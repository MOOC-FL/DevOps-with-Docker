#### Building images​
- Finally, we get to build our own images and get to talk about Dockerfile(opens in a new tab)(opens in a new tab) and why it's so great.
-  Dockerfile is simply a file that contains the build instructions for an image. You define what should be included in the image with different instructions. We'll learn about the best practices here by creating one.
- Let's take a most simple application and containerize it first. Here is a script called "hello.sh"
```bash
#!/bin/sh
echo "Hello, docker!"
```
- First, we will test that it even works. Create the file, add execution permissions and run it:
```bash
$ chmod +x hello.sh
$ ./hello.sh
  Hello, docker!
```
- And now to create an image from it. We will have to create the `Dockerfile` that declares all of the required dependencies. At least it depends on something that can run shell scripts. We will choose Alpine
a small Linux distribution that is often used to create small images.
- Even though we're using Alpine here, you can use Ubuntu during exercises. Ubuntu images by default contain more tools to debug what is wrong when something doesn't work. In chapter 4 we will talk more about why small images are important.

- We will choose exactly which version of a given image we want to use. This guarantees that we don't accidentally update through a breaking change, and we know which images need updating when there are known security vulnerabilities in old images.
- Now create a file and name it "Dockerfile" and put the following instructions inside it:
```bash
# Start from the alpine image that is smaller but no fancy tools
FROM alpine:3.21

# Use /usr/src/app as our workdir. The following instructions will be executed in this location.
WORKDIR /usr/src/app

# Copy the hello.sh file from this directory to /usr/src/app/ creating /usr/src/app/hello.sh
COPY hello.sh .

# Alternatively, if we skipped chmod earlier, we can add execution permissions during the build.
# RUN chmod +x hello.sh

# When running docker run the command will be ./hello.sh
CMD ["./hello.sh"]
```
> Great! We can use the command docker build(opens in a new tab)(opens in a new tab) to turn the Dockerfile to an image.
- By default `docker build` will look for a file named Dockerfile. Now we can run `docker build` with instructions where to build `(.)` and give it a name `(-t <name>):`
```bash
$ docker build -t hello-docker .
 => [internal] load build definition from Dockerfile                                                                                                                                              0.0s
 => => transferring dockerfile: 478B                                                                                                                                                              0.0s
 => [internal] load metadata for docker.io/library/alpine:3.21                                                                                                                                    2.1s
 => [auth] library/alpine:pull token for registry-1.docker.io                                                                                                                                     0.0s
 => [internal] load .dockerignore                                                                                                                                                                 0.0s
 => => transferring context: 2B                                                                                                                                                                   0.0s
 => [1/3] FROM docker.io/library/alpine:3.19@sha256:c5b1261d6d3e43071626931fc004f70149baeba2c8ec672bd4f27761f8e1ad6b                                                                              0.0s
 => [internal] load build context                                                                                                                                                                 0.0s
 => => transferring context: 68B                                                                                                                                                                  0.0s
 => [2/3] WORKDIR /usr/src/app                                                                                                                                                                    0.0s
 => [3/3] COPY hello.sh .                                                                                                                                                                         0.0s
 => exporting to image                                                                                                                                                                            0.0s
 => => exporting layers                                                                                                                                                                           0.0s
 => => writing image sha256:5f8f5d7445f34b0bcfaaa4d685a068cdccc1ed79e65068337a3a228c79ea69c8                                                                                                      0.0s
 => => naming to docker.io/library/hello-docker
```
> Let us ensure that the image exists:
```bash
$ docker image ls
  REPOSITORY            TAG          IMAGE ID       CREATED         SIZE
  hello-docker          latest       5f8f5d7445f3   4 minutes ago   12.9MB
```
> If you're now getting "/bin/sh: ./hello.sh: Permission denied" it's because the `chmod +x hello.sh `was skipped earlier. You can simply uncomment the RUN instruction between COPY and CMD instructions

- Now executing the application is as simple as running `docker run hello-docker``. Try it!
- During the build we see from the output that there are three steps: [1/3], [2/3] and [3/3]. The steps here represent layers(opens in a new tab)(opens in a new tab) of the image so that each step is a new layer on top of the base image (alpine:3.21 in our case).
- Layers have multiple functions. We often try to limit the number of layers to save on storage space but layers can work as a cache during build time. If we just edit the last lines of Dockerfile the build command can start from the previous layer and skip straight to the section that has changed. COPY automatically detects changes in the files, so if we change the hello.sh it will run from step 3/3, skipping 1 and 2. This can be used to create faster build pipelines. We will talk more about optimization in chapter 4.
- It is also possible to manually create new layers on top of an image. Let us now create a new file called additional.txt and copy it inside a container.
- We'll need two terminals, that shall be called 1 and 2 in the following listings. Let us start by running the image:
```bash
# do this in terminal 1
$ docker run -it hello-docker sh
/usr/src/app #
```
- Now we're inside of the container. We replaced the CMD we defined earlier with `sh` and used `-it` to start the container so that we can interact with it.
- In the second terminal we will copy the file inside the container:
```bash
# do this in terminal 2
$ docker ps
  CONTAINER ID   IMAGE          COMMAND   CREATED         STATUS         PORTS     NAMES
  9c06b95e3e85   hello-docker   "sh"      4 minutes ago   Up 4 minutes             zen_rosalind

$ touch additional.txt
$ docker cp ./additional.txt zen_rosalind:/usr/src/app/
```
- The file is created with command `touch` right before copying it in.

Let us ensure that the file is copied inside the container:
```bash
# do this in terminal 1
/usr/src/app # ls
additional.txt  hello.sh
```
- Great! Now we've made a change to the container. We can use command docker diff(opens in a new tab)(opens in a new tab) to check what has changed
```bash
# do this in terminal 2
$ docker diff zen_rosalind
  C /usr
  C /usr/src
  C /usr/src/app
  A /usr/src/app/additional.txt
  C /root
  A /root/.ash_history
```
- The character in front of the file name indicates the type of the change in the container's filesystem: A = added, D = deleted, C = changed. The additional.txt was created and running the command `ls` created the file .ash_history.
> Next we will save the changes as a new image with the command docker commit
```bash
# do this in terminal 2
$ docker commit zen_rosalind hello-docker-additional
  sha256:2f63baa355ce5976bf89fe6000b92717f25dd91172aed716208e784315bfc4fd
$ docker image ls
  REPOSITORY                   TAG          IMAGE ID       CREATED          SIZE
  hello-docker-additional      latest       2f63baa355ce   3 seconds ago    12.9MB
  hello-docker                 latest       444f21cf7bd5   31 minutes ago   12.9MB
```
- Technically the command `docker commit` added a new layer on top of the image `hello-docker`, and the resulting image was given the name `hello-docker-additional`.
-  We will actually not use the command `docker commit` again during this course. This is because defining the changes to the Dockerfile is much more sustainable method of managing changes. No magic actions or scripts, just a Dockerfile that can be version controlled.
- Let's do just that and create hello-docker with v2 tag that includes the file additional.txt. The new file can be added with a RUN(opens in a new tab)(opens in a new tab) instruction:
#### Dockerfile
```bash
# Start from the alpine image
FROM alpine:3.21

# Use /usr/src/app as our workdir. The following instructions will be executed in this location.
WORKDIR /usr/src/app

# Copy the hello.sh file from this location to /usr/src/app/ creating /usr/src/app/hello.sh.
COPY hello.sh .

# Execute a command with `/bin/sh -c` prefix.
RUN touch additional.txt

# When running Docker run the command will be ./hello.sh
CMD ["./hello.sh"]
```
- Now we used the RUN instruction to execute the command `touch additional.txt` which creates a file inside the resulting image. Pretty much anything that can be executed in the container based on the created image, can be instructed to be run with the RUN instruction during the build of a Dockerfile.
- Now build the Dockerfile with docker build -t hello-docker:v2 . and we are done! Let's compare the output of ls:
```bash
$ docker run hello-docker-additional ls
  additional.txt
  hello.sh

$ docker run hello-docker:v2 ls
  additional.txt
  hello.sh
```
- Now we know that all instructions in a Dockerfile except CMD (and one other that we will learn about soon) are executed during build time. CMD is executed when we call docker run, unless we overwrite it.
- It is good to know that you can have distinct Dockerfiles under same project directory by naming these files as `Dockerfile.<something>`. When building a image, just specify the used Dockerfile with `--file` or` -f flag`. For example `docker build -t tester -f Dockerfile.testing` .








