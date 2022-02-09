# Cerebro container image

Contains the docker files for [cerebro](https://github.com/lmenezes/cerebro) project.
Images are periodically uploaded in [labmonkeys/cerebro](https://github.com/labmonkeys-space/app-container/tree/main/cerebro/) quay.io repo.

## Usage

For using a specific version run:

```
docker run -p 9000:9000 quay.io/labmonkeys/cerebro:0.9.4.b142
```

## Configuration

You can configure a custom port for cerebro by using the `CEREBRO_PORT` environment variable which defaults to `9000`.

**Example**

```
docker run -e CEREBRO_PORT=8080 -p 8080:8080 quay.io/labmonkeys/cerebro:0.9.4.b142
```

To access an elasticsearch instance running on localhost:

```
docker run -p 9000:9000 --network=host quay.io/labmonkeys/cerebro:0.9.4.b142
```
