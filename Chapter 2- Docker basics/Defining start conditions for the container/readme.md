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
