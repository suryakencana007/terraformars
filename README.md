## GUIDE Terra Formars Universe

### Notes

`For directory mount volume container: /home/admin/storage`
`For directory mount volume RDS: /home/admin/data` >> node.labels.platform==rds 

```
  ports:
    Postgres
      Master: 54322
      Slave: 54323
    
    Mariadb:
      Master: 33066
      Slave: 33067

    Nats:
      - 14222
      - 18222

```


## Step :TODO

### [01] Setup terraform

1. terraform init aws-iam-policies
2. terraform plan aws-iam-policies
3. terraform apply aws-iam-policies

--------------------------------------

1. terraform init swarm
2. terraform plan swarm
3. terraform apply swarm

### [02] Setup Swarm

1. sshpass -p 'Pwd' ssh -o StrictHostKeyChecking=no admin@54.255.26.132 docker network create web --driver overlay --attachable
2. sshpass -p 'Pwd' ssh -o StrictHostKeyChecking=no admin@54.255.26.132 docker network ls

### [03] Setup Portainer

1. docker -H ssh://admin@54.255.26.132 stack deploy -c portainers/docker-compose.yaml portainer

### [04] Setup Distributed File Storage

1. sshpass -p 'Pwd' ssh -o StrictHostKeyChecking=no admin@54.255.26.132 sudo mkdir -p /home/admin/storage
2. docker -H ssh://admin@54.255.26.132 stack deploy -c resilio/docker-compose.yml resilio-manager
3. docker -H ssh://admin@54.255.26.132 stack deploy -c resilio/stack-worker.yml resilio-worker

### [05] Setup Minio

1. sshpass -p 'Pwd' ssh -o StrictHostKeyChecking=no admin@54.255.26.132 echo "ASA" | docker secret create access_key -
2. sshpass -p 'Pwd' ssh -o StrictHostKeyChecking=no admin@54.255.26.132 echo "vsda" | docker secret create secret_key -
3. docker -H ssh://admin@54.255.26.132 stack deploy -c minio/docker-compose.yml minio


### [06] Setup Traefik

1. open minio browser
2. create bucket `traefik`
2. upload file at minio browser to /traefik >> basic-auth and dynamic.yaml
3. docker -H ssh://admin@54.255.26.132 stack deploy -c traefik/docker-compose.yml traefik


docker registry
gitlab-runner