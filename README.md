# NFS Server

[Original-Design](https://github.com/phcollignon/nfs-server-minikube)

## Run the server

```bash
docker run -d --rm --privileged --name nfs-server -v /var/nfs:/var/nfs nfs-server
```
