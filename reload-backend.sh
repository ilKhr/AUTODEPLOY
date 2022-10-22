#!/bin/sh

IMAGE=ilkhr/mark-backend-t-shirt

cd ./backend
echo "Build new image..."
docker build -t $IMAGE:latest .

cd ../

echo "Stop old $IMAGE"
#https://stackoverflow.com/a/68094750/14274230
docker stop $(docker container ls  | grep $IMAGE | awk '{print $1}')

echo "Apply updates..."
docker run -d  -p 8080:3000 --env-file ./backend/.env --rm $IMAGE

echo "Cleaning up old registry images..."
docker image prune -a -f
