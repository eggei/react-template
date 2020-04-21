#!/bin/bash
container_name=template-test
container_tag=react-template

docker_run="docker run -d --name $container_name -p 8000:80 $container_tag"
existing_container=`docker ps -a -f name=$container_name | grep -w $container_name`

function logger {
    if [ $1 -eq 0 ]; then
        echo "=================================================="
        echo
        echo "Container \"$container_name\" is running on \"localhost:8000\""
        echo "Container ID: $2"
        echo
        echo "=================================================="
    else
        echo "> Failed!"
    fi
}

# Check whether there is a container running with the same name
# If so, remove it before docker run
if [[ $existing_container ]]; then
    docker rm -f $container_name
fi

output=$( $docker_run )
logger $? $output
exit