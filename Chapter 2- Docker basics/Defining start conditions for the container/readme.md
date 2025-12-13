#### Start conditions for the container
- Next, we will start moving towards a more meaningful image. yt-dlp(opens in a new tab)(opens in a new tab) is a program that downloads YouTube and Imgur(opens in a new tab)(opens in a new tab) videos. Let's add it to an image - but this time, we will change our process. Instead of our current process where we add things to the Dockerfile and hope it works, let's try another approach. This time we will open up an interactive session and test stuff before "storing" it in our Dockerfile.
```bash
$ docker run -it ubuntu:24.04

  root@8c587232a608:/# curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
  bash: curl: command not found
```
> ... and, as we already know, curl is not installed - let's add `curl` with `apt-get` again.
```bash
root@8c587232a608:/# apt-get update && apt-get install -y curl
root@8c587232a608:/# curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
```
- At some point, you may have noticed that sudo is not installed either, but since we are root we don't need it.
Next, we will add permissions and run the downloaded binary:
```bash
root@8c587232a608:/# chmod a+rx /usr/local/bin/yt-dlp
root@8c587232a608:/# yt-dlp
/usr/bin/env: 'python3': No such file or directory
```
> Okay, documentation(opens in a new tab)(opens in a new tab) mentions that Python 3.10 or later is needed to run yt-dlp, and it recommends to add an optional dependency ffmpeg for merging the audio and video files. So let us install those:
```bash
root@8c587232a608:/# apt-get install -y python3 ffmpeg
```
```bash
root@8c587232a608:/# yt-dlp

  Usage: yt-dlp [OPTIONS] URL [URL...]

  yt-dlp: error: You must provide at least one URL.
  Type yt-dlp --help to see a list of all options.
```
- It works, we just need to give it a URL.

- So now when we know exactly what we need. Starting FROM ubuntu:24.04, we'll add the above steps to our Dockerfile. We should always try to keep the most prone-to-change rows at the bottom, by adding the instructions to the bottom we can preserve our cached layers - this is a handy practice to speed up the build process when there are time-consuming operations like downloads in the Dockerfile. We also added WORKDIR, which will ensure the videos will be downloaded there.
```bash
FROM ubuntu:24.04

WORKDIR /mydir

RUN apt-get update && apt-get install -y curl python3 ffmpeg
RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
RUN chmod a+x /usr/local/bin/yt-dlp

CMD ["/usr/local/bin/yt-dlp"]
```
- We have also overridden `bash` as our image command (set on the base image) with yt-dlp itself. This will not quite work, but let's see why.

- Let us now build the Dockerfile as image `yt-dlp` and run it:
```bash
$ docker build -t yt-dlp .
  ...

$ docker run yt-dlp

  Usage: yt-dlp [OPTIONS] URL [URL...]

  yt-dlp: error: You must provide at least one URL.
  Type yt-dlp --help to see a list of all options.
```
- So far so good. The natural way to use this image would be to give the URL as an argument but unfortunately, it doesn't work:
```bash
$ docker run yt-dlp https://www.youtube.com/watch?v=uTZSILGTskA

  docker: Error response from daemon: failed to create task for container: failed to create shim task: OCI runtime create failed: runc create failed: unable to start container process: exec: "https://www.youtube.com/watch?v=uTZSILGTskA": stat https://www.youtube.com/watch?v=uTZSILGTskA: no such file or directory: unknown.
  ERRO[0000] error waiting for container: context canceled
```
> As we now know, the argument we gave is replacing the command or `CMD`:
```bash
$ docker run -it yt-dlp ps
  PID TTY          TIME CMD
    1 pts/0    00:00:00 ps
$ docker run -it yt-dlp ls -l
total 0
$ docker run -it yt-dlp pwd
/mydir
```
- We need a way to append something to the command. Fortunately, we can achieve this by using ENTRYPOINT(opens in a new tab)(opens in a new tab) to specify the main executable, and Docker will then append our arguments to it.
```bash
FROM ubuntu:24.04

WORKDIR /mydir

RUN apt-get update && apt-get install -y curl python3 ffmpeg
RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
RUN chmod a+x /usr/local/bin/yt-dlp

# Replacing CMD with ENTRYPOINT
ENTRYPOINT ["/usr/local/bin/yt-dlp"]
```
#### And now it works like it should:
```bash
$ docker build -t yt-dlp .
$ docker run yt-dlp https://www.youtube.com/watch?v=XsqlHHTGQrw
[youtube] Extracting URL: https://www.youtube.com/watch?v=XsqlHHTGQrw
[youtube] XsqlHHTGQrw: Downloading webpage
[youtube] XsqlHHTGQrw: Downloading tv client config
[youtube] XsqlHHTGQrw: Downloading tv player API JSON
[youtube] XsqlHHTGQrw: Downloading web safari player API JSON
[youtube] XsqlHHTGQrw: Downloading player 0004de42-main
[youtube] XsqlHHTGQrw: Downloading m3u8 information
[info] XsqlHHTGQrw: Downloading 1 format(s): 137+251
[download] Sleeping 4.00 seconds as required by the site...
[download] Destination: Master’s Programme in Computer Science ｜ University of Helsinki [XsqlHHTGQrw].f137.mp4
[download] 100% of   77.78MiB in 00:00:03 at 22.04MiB/s    
[download] Destination: Master’s Programme in Computer Science ｜ University of Helsinki [XsqlHHTGQrw].f251.webm
[download] 100% of    3.55MiB in 00:00:00 at 13.38MiB/s  
[Merger] Merging formats into "Master’s Programme in Computer Science ｜ University of Helsinki [XsqlHHTGQrw].mkv"
Deleting original file Master’s Programme in Computer Science ｜ University of Helsinki [XsqlHHTGQrw].f137.mp4 (pass -k to keep)
Deleting original file Master’s Programme in Computer Science ｜ University of Helsinki [XsqlHHTGQrw].f251.webm (pass -k to keep)
```
- With `ENTRYPOINT` docker run now executed the combined `/usr/local/bin/yt-dlp https://www.youtube.com/watch?v=uTZSILGTskA` inside the container!

- `ENTRYPOINT` vs `CMD` can be confusing
- - in a properly set up image, such as our `yt-dlp`, the command represents an argument list for the entrypoint. By default, the `entrypoint` in Docker is set as `/bin/sh -c` and this is passed if no entrypoint is set. This is why giving the path to a script file as CMD works: you're giving the file as a parameter to `/bin/sh -c.`

- If an image defines both, then the `CMD` is used to give default arguments(opens in a new tab)(opens in a new tab) to the `entrypoint`. Let us now add a `CMD` to the Dockerfile:
```bash
FROM ubuntu:24.04

WORKDIR /mydir

RUN apt-get update && apt-get install -y curl python3 ffmpeg
RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
RUN chmod a+x /usr/local/bin/yt-dlp

ENTRYPOINT ["/usr/local/bin/yt-dlp"]

# define a default argument
CMD ["https://www.youtube.com/watch?v=Aa55RKWZxxI"]
```
- Now (after building again) the image can be run without arguments to download the video defined in CMD:
```bash
$ docker run yt-dlp

  youtube] Extracting URL: https://www.youtube.com/watch?v=Aa55RKWZxxI
  [youtube] Aa55RKWZxxI: Downloading webpage
  [youtube] Aa55RKWZxxI: Downloading ios player API JSON
  [youtube] Aa55RKWZxxI: Downloading android player API JSON
  ...
  [download] 100% of   57.04MiB in 00:00:16 at 3.38MiB/s 
  ...
```
- The argument defined by CMD can be overridden by giving one in the command line:
```bash
$ docker run yt-dlp https://www.youtube.com/watch?v=DptFY_MszQs
  [youtube] Extracting URL: https://www.youtube.com/watch?v=XsqlHHTGQrw
  [youtube] XsqlHHTGQrw: Downloading webpage 
  [youtube] XsqlHHTGQrw: Downloading tv client config
  [youtube] XsqlHHTGQrw: Downloading tv player API JSON
  [youtube] XsqlHHTGQrw: Downloading web safari player API JSON
  [youtube] XsqlHHTGQrw: Downloading player 0004de42-main
  [youtube] XsqlHHTGQrw: Downloading m3u8 information
  [info] XsqlHHTGQrw: Downloading 1 format(s): 137+251
  [download] Sleeping 4.00 seconds as required by the site...
  [download] Destination: Master’s Programme in Computer Science ｜ University of Helsinki [XsqlHHTGQrw].f137.mp4
  [download] 100% of   77.78MiB in 00:00:04 at 18.80MiB/s  
 ...
```
> In some cases, YouTube has prevented the usage of the downloader for some users. If that happens to you, downloading from Imgur should work, eg. `docker run yt-dlp https://imgur.com/gallery/bro-stepped-on-his-shoes-UnI65gt`

- There are two ways to set the ENTRYPOINT and CMD: exec form and shell form. We have been using the exec form, in which the command itself is executed. The exec form is generally preferred over the shell form, because in the shell form the command that is executed is wrapped with /bin/sh -c, which can result in unexpected behaviour. However, the shell form can be useful in certain situations, for example, when you need to evaluate environment variables in the command like $MYSQL_PASSWORD or similar.

- In the shell form, the command is provided as a string without brackets. In the exec form the command and its arguments are provided as a list (with brackets), see the table below:












