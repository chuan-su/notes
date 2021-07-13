# docker run

## docker run <IMAGE> <MULTIPLE COMMANDS>

```bash
docker run - w /usr/src/app image /bin/bash -c "mvn clean package;jar -jar app.jar"
```

[Set working directory](https://docs.docker.com/engine/reference/commandline/run/#set-working-directory--w)

The `-w` lets the command being executed inside the given directory, here `/usr/src/app`. If the path does not exit it is created inside the container.

