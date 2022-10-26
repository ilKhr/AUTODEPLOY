## Create user
1. Create user in server
```sh
    adduser github-runner
```

2. Add use sudo
```sh
    usermod -aG sudo github-runner
```

3. Checkout to new user and create ssh folder
```sh
    # Switch to the new user
    su - github-runner
```

```sh
    # Create the SSH folder
    mkdir ~/.ssh
```

```sh
    chmod 700 ~/.ssh
```

4. Add `id_rsa.pub` to here

May create here [rsa-generate](https://www.devglan.com/online-tools/rsa-encryption-decryption)

```sh
    # Create and open the file where SSH will look for your public key
    nano ~/.ssh/authorized_keys
```

```sh
    chmod 600 ~/.ssh/authorized_keys
```

## Add user to docker group
```sh
    sudo usermod -aG docker github-runner
```

## Setting docker scripts
1. Create file and add this script for **backend**
```sh
    nano reload-backend.sh
```

```sh
#!/bin/sh

#Image name
IMAGE=ilkhr/mark-backend-t-shirt
#ID image where will be stop
OLD_IMAGE_ID=$(docker container ls | grep $IMAGE | awk '{print $1}')
#Root directory path
DIRECTORY=/home/ilya/Projects/t-shirt_store


echo "Build new image..."
docker build -t $IMAGE:latest $DIRECTORY/backend

echo "Stop old $IMAGE"
docker stop $OLD_IMAGE_ID

echo "Apply updates..."
docker run -d  -p 8080:3000 --env-file $DIRECTORY/backend/.env --rm $IMAGE

echo "Cleaning up old registry images..."
#docker image prune -a -f
docker image prune
```

2. Create file and add this script for **frontend**

```sh
    build-backend-docker.sh
```

```sh
#!/bin/sh

#Image name
IMAGE=ilkhr/mark-frontend-t-shirt
#ID image where will be stop
OLD_IMAGE_ID=$(docker container ls | grep $IMAGE | awk '{print $1}')
#Root directory path
DIRECTORY=/home/ilya/Projects/t-shirt_store

echo "Build new image..."
docker build -t $IMAGE:latest $DIRECTORY/frontend

docker container ls | grep $IMAGE | awk '{print $1}'

echo "Stop old $IMAGE"
docker stop $OLD_IMAGE_ID

echo "Apply updates..."
docker run -d  -p 7979:80 --rm $IMAGE

echo "Cleaning up old registry images..."

docker image prune
```

3. Add start script  **backend**
```sh
    nano start-backend.sh
```

```sh
#!/bin/bash

docker run -d  -p 7979:80 --rm ilkhr/mark-backend-t-shirt
```

4. Add start script  **frontend**
```sh
    nano start-frontend.sh
```

```sh
#!/bin/bash

docker run -d  -p 7979:80 --rm ilkhr/mark-frontend-t-shirt
```

## Settings repository/.github/workflows/main.yml
[Docs for ssh connect](https://github.com/appleboy/ssh-action)

1.
```yml
name: remote ssh command
on: [push]
jobs:

  build:
    name: Build
    runs-on: ubuntu-latest
    steps:
      - name: executing remote ssh commands using ssh key
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.HOST }}
          username: ${{ secrets.USERNAME }}
          key: ${{ secrets.KEY }}
          port: ${{ secrets.PORT }}
          script: |
            y | /home/ilya/Projects/t-shirt_store/reload-backend.sh \
            y | /home/ilya/Projects/t-shirt_store/reload-frontend.sh
```

2. Add github secrets
