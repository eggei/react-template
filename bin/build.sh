#!/bin/bash

# Check for the node_modules, if exists build the production code, if not prompt the developer

build_script="node_modules/webpack/bin/webpack.js --mode production"

function evaluate {
    if [[ $1 == 'y' ]]; then
        npm install && eval "$build_script"
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
    echo "> Do you want to install the dependencies for building the production code? (y|n)"
    read decision
    evaluate $decision
else
    eval "$build_script"
    exit
fi