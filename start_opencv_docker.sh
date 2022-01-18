#!/usr/bin/env bash
docker run -it --rm --name opencv  -v $HOME/src/nordstrom/fusionstream/training-tools/docker/opencv/src:/root/src opencv:3.0.2 bash
