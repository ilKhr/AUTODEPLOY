#!/bin/sh

IMAGE="ilkhr/trip-bot"


echo "Download new image..."
echo "$IMAGE"
docker pull $IMAGE:latest
echo "Cleaning up old registry images..."
docker image prune -a -f
echo "Apply updates..."
docker run -d --env-file /home/vladfcat/Projects/trip-bot/.env --rm $IMAGE
