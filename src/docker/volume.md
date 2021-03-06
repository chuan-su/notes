# Volume

```Dockerfile
VOLUME ["/data"]
```

The `VOLUME` creates a mount point to **the volume on the host** that holds the data persisted by the docker container during container runtime.

When running a docker container, the volume (directory) is created at the Docker root directory of the host machine - `/var/lib/docker/volumes`.


The name of volume is autogenerated and extreamly long, which are often referred to as "unnamed" or "anonymous".

However if the mount point is specified in the `docker run -v` or `docker run --mount` command, Docker will create and use the volume as specified on the host instead of the default volume specified in the Dockerfile.

## Example

In the offical [mysql Dockerfile](https://github.com/docker-library/mysql/blob/master/8.0/Dockerfile.debian#L87):

```Dockerfile
VOLUME /var/lib/mysql
```

If we run the mysql container

```bash
docker run mysql:8
```

The mysql container instance will use the default mount point which is specified by the `VOLUME` instruction in the Dockerfile. And in my host,the volume is created at

```bash
/var/lib/docker/volumes/00b4488b017762870295a3894aa1d2ff2b3c6126e445273ef45e279f6ee8ddf9
```

If we run the mysql container

```bash
docker run -v /my/own/datadir:/var/lib/mysql mysql:8
```

This command mounts `/my/own/datadir` directory on my host as `/var/lib/mysql` inside the container instead.

## Where to Store Data

There are several ways to store data used by applications that run in Docker containers. We encourage users of the mysql images to familiarize themselves with the options available, including:

- Let Docker manage the storage of your database data by [writing the database files to disk on the host system using its own internal volume managemen](https://docs.docker.com/engine/tutorials/dockervolumes/#adding-a-data-volume). This is the default and is easy and fairly transparent to the user. The downside is that the files may be hard to locate for tools and applications that run directly on the host system, i.e. outside containers.


- Create a data directory on the host system (outside the container) and [mount this to a directory visible from inside the container](https://docs.docker.com/engine/tutorials/dockervolumes/#mount-a-host-directory-as-a-data-volume). This places the database files in a known location on the host system, and makes it easy for tools and applications on the host system to access the files. The downside is that the user needs to make sure that the directory exists, and that e.g. directory permissions and other security mechanisms on the host system are set up correctly.

The Docker documentation is a good starting point for understanding the different storage options and variations, and there are multiple blogs and forum postings that discuss and give advice in this area. We will simply show the basic procedure here for the latter option above:

1. Create a data directory on a suitable volume on your host system, e.g. /my/own/datadir.

2. Start your mysql container like this:

```bash
$ docker run --name some-mysql -v /my/own/datadir:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:tag
```

The `-v /my/own/datadir:/var/lib/mysql` part of the command mounts the `/my/own/datadir` directory from the underlying host system as `/var/lib/mysql` inside the container, where MySQL by default will write its data files.

Reference:
- [https://hub.docker.com/_/mysql/](https://hub.docker.com/_/mysql/)
