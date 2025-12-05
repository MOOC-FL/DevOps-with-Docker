$ docker container rm --force 4287205d2a09
4287205d2a09
$ docker container ls
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
$ docker run -d --name web1 nginx
839d60c31f481a66d0b4fde6e4bfa5ddc9dd4b66fe02eae596d4d4d1d57ebc76
$ docker run -d -name web2 nginx
unknown shorthand flag: 'n' in -name

Usage:  docker run [OPTIONS] IMAGE [COMMAND] [ARG...]

Run 'docker run --help' for more information
$ docker run -d --name web2 nginx
79926d3cc0a1b5abe920fd183c34fe36b381d6b00bd13dc39e349adb99b77c11
$ docker run -d --name web3 nginx
c341e06536d7c512a73962aaef428a71dc94c986f44e7eb09a3e5d35b5653640

