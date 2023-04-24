# NFS Server

[Original-Design](https://github.com/phcollignon/nfs-server-minikube)

## Utility containers

```bash
# Load jsonnet container
docker run -it --rm --name jsonnet -v "$(pwd):/home/mnt" jsonnet
```

## Run the server

```bash
docker run -d --rm --privileged --name nfs-server -v /var/nfs:/var/nfs nfs-server
```
