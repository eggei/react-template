#!/bin/bash

# Check for the node_modules, if exists serve the code in the browser, if not prompt the developer

serve_script="node_modules/webpack-dev-server/bin/webpack-dev-server.js --config ./webpack.config.js --open"

function evaluate {
    if [[ $1 == 'y' ]]; then
        npm install && eval "$serve_script"
        exit
    elif [[ $1 == 'n' ]]; then
        echo '> Exited!'
        exit
    else
        echo "> Please type \"n\" (no) or \"y\" (yes) - do you want to install dependencies?"
        read decision
        evaluate $decision
        exit
    fi
}

if [[ ! -d './node_modules' ]]; then
    echo '==============================================='
    echo " Cannot find dependencies (node_modules)"
    echo "> Do you want to install the dependencies for serving the code in the browser? (y|n)"
    read decision
    evaluate $decision
else
    eval "$serve_script"
    exit
fi