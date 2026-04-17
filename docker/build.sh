#!/bin/bash
source config.env
docker build  -f Dockerfile -t $IMAGE_NAME .