#### Volumes in action
- Next we're going to set up the project management application Redmine(opens in a new tab)(opens in a new tab), a PostgreSQL database and Adminer(opens in a new tab)(opens in a new tab), a graphical interface for database administration.
- All of the above have official Docker images available as we can see from Redmine(opens in a new tab)(opens in a new tab), Postgres(opens in a new tab)(opens in a new tab) and Adminer(opens in a new tab)(opens in a new tab), respectively. The officiality of the containers is not that important, just that we can expect that it will have some support. We could also, for example, setup Wordpress or a MediaWiki inside containers in the same manner if you were interested in running existing applications inside Docker. You could even set up an application monitoring tool such as Sentry(opens in a new tab)(opens in a new tab).
- In https://hub.docker.com/_/redmine(opens in a new tab)(opens in a new tab) there is a list of different tagged versions:
- We can use any of the available images.
- From the section Environment variables we can see that all versions can use `REDMINE_DB_POSTGRES` environment variable to set up a `Postgres` database. Before moving forward, let's setup `Postgres`.
- In https://hub.docker.com/_/postgres(opens in a new tab)(opens in a new tab) there is a sample compose file under the section "via docker-compose or docker stack deploy". Let's strip that down as follows
```bash
services:
  db:
    image: postgres:17
    restart: unless-stopped
    environment:
      POSTGRES_PASSWORD: example
    container_name: db_redmine
```
> Note that `restart: always` was changed to `unless-stopped`, that will keep the container running unless we explicitly stop it. With `always` the stopped container is started after reboot, for example. See here(opens in a new tab)(opens in a new tab) for more.
- Under the section Where to store data(opens in a new tab)(opens in a new tab), we can see that for the `Postgres` version 18 and above the `/var/lib/postgresql` should be mounted separately to preserve the data. Note, if the version 17 or below is used, the mounting is done to `/var/lib/postgresql/data`.
- There are two options for doing the mounting. We could use a bind mount like previously and mount an easy-to-locate directory for storing the data. Now, let's use the other option, a Docker managed volume(opens in a new tab)(opens in a new tab).
- Let's run the Docker Compose file without setting anything new:
```bash
$ docker compose up

  ✔ Network redmine_default  Created                                                                                              0.0s
  ✔ Container db_redmine     Created                                                                                              0.2s
  Attaching to db_redmine
  db_redmine  | The files belonging to this database system will be owned by user "postgres".
  db_redmine  | This user must also own the server process.
  ...
  db_redmine  | 2025-03-01 14:05:52.340 UTC [1] LOG:  starting PostgreSQL 13.2 on aarch64-unknown-linux-musl, compiled by gcc (Alpine 10.2.1_pre1) 10.2.1 20201203, 64-bit
  db_redmine  | 2025-03-01 14:05:52.340 UTC [1] LOG:  listening on IPv4 address "0.0.0.0", port 5432
  db_redmine  | 2025-03-01 14:05:52.340 UTC [1] LOG:  listening on IPv6 address "::", port 5432
  db_redmine  | 2025-03-01 14:05:52.342 UTC [1] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
  db_redmine  | 2025-03-01 14:05:52.345 UTC [46] LOG:  database system was shut down at 2025-03-01 14:05:52 UTC
  db_redmine  | 2025-03-01 14:05:52.347 UTC [1] LOG:  database system is ready to accept connections
```
- The image initializes the data files in the first start. Let's terminate the container with ^C. Compose uses the current directory as a prefix for container and volume names so that different projects don't clash (The prefix can be overridden with `COMPOSE_PROJECT_NAME` environment variable, if needed).
- Let's inspect if there was a volume created with `docker container inspect db_redmine | grep -A 5 Mounts`
```bash
"Mounts": [
    {
        "Type": "volume",
        "Name": "2d86a2480b60743147ce88e8e70b612d10b4c4151779b462baf4e81b84061ef5",
        "Source": "/var/lib/docker/volumes/2d86a2480b60743147ce88e8e70b612d10b4c4151779b462baf4e81b84061ef5/_data",
        "Destination": "/var/lib/postgresql/data",
```
- And indeed there is one! So, despite us not configuring one explicitly, an anonymous volume was automatically created for us.
- Now, if we check out `docker volume ls`, we can see that a volume with the name "2d86a2480b60743147ce88e8e70b612d10b4c4151779b462baf4e81b84061ef5" exists.
```bash
$ docker volume ls
  DRIVER              VOLUME NAME
  local     2d86a2480b60743147ce88e8e70b612d10b4c4151779b462baf4e81b84061ef5
```
- There may be more volumes on your machine. If you want to get rid of them you can use `docker volume prune`. Let's put the whole "application" down now with `docker compose down`.
- Instead of the randomly named volume, we better define one explicitly. Let us change the definition as follows:
```bash
services:
  db:
    image: postgres:17
    restart: unless-stopped
    environment:
      POSTGRES_PASSWORD: example
    container_name: db_redmine
    volumes:
      - database:/var/lib/postgresql/data

volumes:
  database:
```
- Now, after running docker compose up again, let us check what it looks like:
```bash
$ docker volume ls
  DRIVER              VOLUME NAME
  local               redmine_database

$ docker container inspect db_redmine | grep -A 5 Mounts
"Mounts": [
    {
        "Type": "volume",
        "Name": "redmine_database",
        "Source": "/var/lib/docker/volumes/ongoing_redminedata/_data",
        "Destination": "/var/lib/postgresql/data",
```
- Ok, looks a bit more human-readable! You might wonder where the mount name redmine_database came from. Docker compose determines the project name from the directory in which the Compose file is located and prepends it to the provided volumes
  - Now that Postgres is running, it is time to add Redmine
  - The container seems to require just two environment variables.
```bash
redmine:
  image: redmine:5.1-alpine
  environment:
    - REDMINE_DB_POSTGRES=db
    - REDMINE_DB_PASSWORD=example
  ports:
    - 9999:3000
  depends_on:
    - db
```
> Notice the depends_on(opens in a new tab)(opens in a new tab) declaration. This makes sure that the db service is started first. `depends_on` doesn't guarantee that the database is up, just that it is started first. **The Postgres server** is accessible with the DNS name "db" from the Redmine service as discussed in the section Docker networking.
- Now, when you run `docker compose up` you will see a bunch of database migrations running first.
```bash
  redmine_1  | I, [2024-03-03T10:59:20.956936 #25]  INFO -- : Migrating to Setup (1)
  redmine_1  | == 1 Setup: migrating =========================================================
  ...
  redmine_1  | [2024-03-03 11:01:10] INFO  ruby 3.2.3 (2024-01-30) [x86_64-linux]
  redmine_1  | [2024-03-03 11:01:10] INFO  WEBrick::HTTPServer#start: pid=1 port=3000
```
- As the documentation(opens in a new tab)(opens in a new tab) mentions, the image creates files to /usr/src/redmine/files and those are better to be persisted. The Dockerfile has this line(opens in a new tab)(opens in a new tab) where it declares that a volume is created. Again Docker will create the volume, but it will be handled as an anonymous volume that is not managed by the Docker Compose, so it's better to create it explicitly.

With that in mind, our configuration changes to this:
```bash
services:
  db:
    image: postgres:17
    restart: unless-stopped
    environment:
      POSTGRES_PASSWORD: example
    container_name: db_redmine
    volumes:
      - database:/var/lib/postgresql/data
  redmine:
    image: redmine:5.1-alpine
    environment:
      - REDMINE_DB_POSTGRES=db
      - REDMINE_DB_PASSWORD=example
    ports:
      - 9999:3000
    volumes:
      - files:/usr/src/redmine/files
    depends_on:
      - db

volumes:
  database:
  files:
```
- Now we can use the application with our browser through http://localhost:9999(opens in a new tab)(opens in a new tab). After some changes inside the application, we could inspect the changes that happened in the image and check that no extra meaningful files got written to the container:
```bash
$ docker container diff $(docker compose ps -q redmine)
  C /usr/src/redmine/config/environment.rb
  ...
  C /usr/src/redmine/tmp/pdf
```
- Probably not.
- We could use command `psql` inside the Postgres container to interact with the database by running
```bash
docker container exec -it db_redmine psql -U postgres
```
- The `docker compose exec` command will by default enter container in interactive mode and allocate `TTY` without explicitly passing `-it` flag as we did previously with docker exec command. The same method can be used to create backups with `pg_dump`:
```bash
docker container exec db_redmine pg_dump -U postgres > redmine.dump
```
- Rather than using the archaic command line interface to access Postgres, let us now set up the database Adminer(opens in a new tab)(opens in a new tab) to the application.

After a look at the documentation(opens in a new tab)(opens in a new tab), the setup is straightforward:
```java
adminer:
  image: adminer:4
  restart: always
  environment:
    - ADMINER_DESIGN=galkaev
  ports:
    - 8083:8080
```
- Now when we run the application we can access the adminer from http://localhost:8083(opens in a new tab)(opens in a new tab):

- Add alt
- Setting up the adminer is straightforward since it will be able to access the database through the Docker network. You may wonder how the adminer finds the Postgres database container. We provide this information to Redmine using an environment variable:
```bash
  redmine:
    environment:
      - REDMINE_DB_POSTGRES=db
```
- Adminer actually assumes that the database has DNS name db so with this name selection, we didn't have to specify anything. If the database has some other name, we have to pass it to adminer using an environment variable:
```bash
  adminer:
    environment:
      - ADMINER_DEFAULT_SERVER=database_server
```



 



