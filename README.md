# Learn_Docker

boot.dev Learn Docker course

## Info about the docker environment

docker info

## Docker container usage details

docker stats

## List containers (running... add -a for inactive)

docker ps
docker ps -a

## Stop a container with a specific id

docker stop d5b49030fb04

## Remove the container

docker rm d5b49030fb04

## Run a specific docker container detached

- (Ghost is a wordpress like server) with a dedicated volume

docker run -d -e NODE_ENV=development -e url=http://localhost:3001 -p 3001:2368\
-v ghost-vol:/var/lib/ghost ghost

## Get a list of commands

docker help

## In some cases help needs -- prefix

docker volume --help

## List volumes -- These are file systems hosted outside of the destructive container

docker volume ls
docker volume rm ghost-vol

## Run the getting-started docker image detached

- The nnnn:nn notation is external to internal port forwarding
- IE 8965 on the host is pointed to 80 in the container

docker run -d -p 8965:80 docker/getting-started

## Run commands in a specific container

docker exec e9dedcf10548 ls
docker exec e9dedcf10548 touch hacker.log
docker exec e9dedcf10548 ls
docker exec e9dedcf10548 netstat -ltnp | grep 80

## Start an interactive shell

docker exec -it e9dedcf10548 /bin/sh

## Create a container in a specific network (none to remove network access)

docker run -d --network none docker/getting-started
docker exec 231e3183f1b8 ping google.com -W 2

## Working with Caddy -- Loadbalancer

docker pull caddy

### Run multiple containers on different ports

docker run -d -p 8881:80 -v $PWD/index1.html:/usr/share/caddy/index.html caddy
docker run -d -p 8882:80 -v $PWD/index2.html:/usr/share/caddy/index.html caddy

### Create internal network for Caddy / this environment

docker network create caddytest
docker network ls

### Run containers in specific network

docker run --network caddytest -d -p 8881:80 -v $PWD/index1.html:/usr/share/caddy/index.html caddy
docker run --network caddytest -d -p 8882:80 -v $PWD/index2.html:/usr/share/caddy/index.html caddy

### Run interactive shell to test connectivity

docker run -it --network caddytest docker/getting-started /bin/sh

### Run Caddy to loadbalance requests between the 2 containers

docker run --network caddytest --name caddy1 -d -p 8881:80 -v $PWD/index1.html:/usr/share/caddy/index.html caddy
docker run --network caddytest --name caddy2 -d -p 8882:80 -v $PWD/index2.html:/usr/share/caddy/index.html caddy
docker run -d --network caddytest --name caddy_balancer -p 8880:80 -v $PWD/Caddyfile:/etc/caddy/Caddyfile caddy

## Build from Dockerfile

docker build . -t goserver:latest

## Run from build

docker run -p 8010:8010 goserver

## Build with a specific / non standard named Dockerfile

docker build -t bookbot -f Dockerfile.py .

## Run built container

docker run bookbot

## Debugging

docker run -d --name logdate alpine sh -c 'while true; do echo "LOGGING: $(date)"; sleep 1; done'

## Get logs for a specific container (-f follow/show live, --tail x = last x lines)

docker logs cc18f1fe9a00
docker logs cc18f1fe9a00 -f
docker logs cc18f1fe9a00 --tail 5

## Stress testing -- also specifying a name for ease of use

docker run -d --name cpu-stress alexeiled/stress-ng --cpu 2 --timeout 10m
docker run -d --name mem-stress alexeiled/stress-ng --vm 1 --vm-bytes 1G --timeout 10m

### Stats from Docker / system

docker stats

### Stats from in the containers

docker top cpu-stress
docker top mem-stress

## Pushing to docker hub (public by default) and version management

### Updates "latest" tag

docker build . -t akupython/goserver

### Updates to a specific tag

docker build . -t akupython/goserver:0.2.0

### Running a specific tag / version

docker run -p 8991:8991 akupython/goserver:0.2.0

### Push / Pull a specific tag

docker push akupython/goserver:0.2.0
docker pull akupython/goserver:0.2.0

### Good practice to update tag and latest

docker build -t akupython/goserver:0.3.0 -t akupython/goserver:latest .
docker push akupython/goserver --all-tags
