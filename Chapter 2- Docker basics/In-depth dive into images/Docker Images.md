- The first result, `hello-world`, is an official image. Official images(opens in a new tab)(opens in a new tab) are curated and reviewed by Docker, Inc. and are usually actively maintained by the authors. They are built from repositories in the docker-library(opens in a new tab)(opens in a new tab).
-  When browsing the CLI's search results, you can recognize an official image from the "[OK]" in the "OFFICIAL" column and also from the fact that the image's name has no prefix (aka organization/user). When browsing Docker Hub, the page will show "Docker Official Images" as the repository, instead of a user or organization. For example, see the Docker Hub page
  of the `hello-world`
 - The other results are not official images. Docker Hub page of the second result mentions This container image is no longer maintained and its use is discouraged. Docker Hub page of the third result doesn't tell us anything useful, so we don't have a clue what the image is meant for.

- There are also other Docker registries competing with Docker Hub, such as Quay(opens in a new tab)(opens in a new tab). By default, docker search will only search from Docker Hub, but to search a different registry, you can add the registry address before the search term,
for example, `docker search quay.io/hello`. Alternatively, you can use the registry's web pages
to search for images. Take a look at the page of podman/hello image on Quay(opens in a new tab)(opens
in a new tab). The page shows the command to use to pull the image, which reveals that we can
 also pull images from hosts other than Docker Hub:
```bash
docker pull quay.io/podman/hello
```
> So, if the host's name (here: quay.io) is omitted, it will pull from Docker Hub by default.
#### A detailed look into an image​
- Let's go back to a more relevant image than 'hello-world', the Ubuntu image, one of the most common Docker images to use as a base for your own image.
- Let's pull Ubuntu and look at the first lines:
```bash
$ docker pull ubuntu
  Using default tag: latest
  latest: Pulling from library/ubuntu
```
- Since we didn't specify a tag, Docker defaulted to `latest`, which is usually the latest image built and pushed to the registry. However, in this case, the repository's README
 says that the `ubuntu:latest` tag points to the "latest LTS" instead since that's the version recommended for general use.
Images can be tagged to save different versions of the same image. You define an image's tag by adding `:<tag> `after the image's name.
- Ubuntu's Docker Hub page(opens in a new tab)(opens in a new tab) reveals that there's a tag named 25.04 which promises us that the image is based on Ubuntu 25.04. Let's pull that as well:
 ```bash
$ docker pull ubuntu:25.04

  25.04: Pulling from library/ubuntu
  c2ca09a1934b: Downloading [============================================>      ]  34.25MB/38.64MB
  d6c3619d2153: Download complete
  0efe07335a04: Download complete
  6b1bb01b3a3b: Download complete
  43a98c187399: Download complete
  ```
- Images are composed of different layers that are downloaded in parallel to speed up the download. Images being made of layers also have other aspects and we will talk about them in part 3.
- We can also tag images locally for convenience, for example, `docker tag ubuntu:25.04 ubuntu:noble_numbat` creates the `tag ubuntu:noble_numbat` which refers to `ubuntu:25.04`.

- Tagging is also a way to "rename" images. `Run docker tag ubuntu:25.04 fav_distro:noble_numbat` and check `docker image ls` to see what effects the command had.
- To summarize, an image name may consist of 3 parts plus a tag. Usually like the following: `registry/organisation/image:tag`. But may be as short as `ubuntu`, then the registry will default to Docker hub, organisation to library and tag to latest. The organisation may also be a user, but calling it an organisation may be more clear.

