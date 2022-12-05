# GraphDB Docker

## How to run?
```
docker run -d \
    --name graphdb \
    -p 7200:7200 \
    --restart unless-stopped \
    ghcr.io/maastrichtu-cds/fair_tools_docker-graphdb/docker-graphdb:latest
```
