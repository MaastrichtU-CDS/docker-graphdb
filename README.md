# GraphDB Docker

## How to run?
```
docker run -d \
    --name graphdb \
    -p 7200:7200 \
    --restart unless-stopped \
    jvsoest/graphdb-free:9.2.0
```