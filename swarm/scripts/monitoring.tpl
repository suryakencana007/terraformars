#!/bin/bash

mkdir -p /home/admin/{storage/traefik,data}

docker network create -d overlay proxy

echo "${ACCESS_KEY}" | docker secret create access_key -
echo "${SECRET_KEY}" | docker secret create secret_key -

git clone https://github.com/zironycho/swarmprom.git
cd swarmprom
docker stack deploy -c docker-compose-traefik.yml mon

cd ..
git clone https://github.com/suryakencana007/terraformars.git
cd terraformars

docker stack deploy -c portainers/docker-compose.yaml portainers

cp traefik/basic-auth /home/admin/storage/traefik/basic-auth
cp traefik/dynamic.yaml /home/admin/storage/traefik/dynamic.yaml
docker stack deploy -c traefik/docker-compose.yml traefik
docker stack deploy -c traefik/docker-compose.yml traefik


docker stack deploy -c resilio/docker-compose.yml resilio-manager
docker stack deploy -c resilio/stack-worker.yml resilio-worker