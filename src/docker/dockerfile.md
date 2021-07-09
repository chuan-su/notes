# Dockerfile

The default working directory is root `/`.

`WORKDIR` is used to set working directory for any `RUN`, `COPY`, `ADD`, `ENTRYPOINT`, `CMD` instructions. And the directory is created if it does not exist.

## ENTRYPOINT and CMD

`ENTRYPOINT` + `CMD` = default container command arguments

Thus

```Dockerfile
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["java", "-jar", "app.jar"]
```

Is equivalent to

```Dockerfile
ENTRYPOINT ["/docker-entrypoint.sh", "java", "-jar", "app.jar"]
```

### Override CMD and ENTRYPOINT

Specifying `CMD` in `Dockerfile` merely creates a default value and can be overriden by `docker run`

For the `Dockerfile` above, if we we invoke

```bash
docker run myservice java -DlogLevel=debug -jar app.jar
```

The container will be created with the following arguments:

```Dockerfile
["/docker-entrypoint.sh", "java", "-DlogLevel=debug" "-jar", "app.jar"]
```

To override the `ENTRYPOINT` declared in a `Dockerfile`, specify `docker run --entrypoint` flag.

```Dockefile
docker run --entrypoint /docker-entrypoint2.sh myservice
```

To reset the container entrypoint, pass an empty string:

```Dockerfile
docker run --entrypoint="" myservice bash
```
*Note* this also overrides the `CMD` command with `bash`.

## ARG

```Dockefile
ARG GCLOUD_SDK_VERSION=286.0.0-alpine

FROM google/cloud-sdk:$GCLOUD_SDK_VERSION
```

The `ARG` defines a variable that users can pass at image build-time

```bash
docker build --build-arg GCLOUD_SDK_VERSION=290.0.0 .
```

Note the `.` dot is representing the context where the docker image is built. Typically for the `COPY context/path/file /container/workdir`

To build the image from another `Dockerfile`:

```bash
docker build --build-arg GCLOUD_SDK_VERSION=290.0.0 -f path/to/Dockefile .
```
