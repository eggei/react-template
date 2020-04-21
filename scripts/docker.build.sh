#!/bin/bash

container_name=template-test
container_tag=react-template

# Pass proxy settings in docker build process in needed
docker_build="\
    docker build \
    -t react-template \
    ./ \
"
docker_run="docker run -d --name $container_name -p 8000:80 $container_tag"



    $docker_build
    if [ $? -eq 0 ]; then
        echo "> Done! - \"npm run docker:run\" to run this container."
    else
        echo "> Failed!"
    fi
