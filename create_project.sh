#!/bin/bash

while [ $# -gt 0 ] ; do
    case $1 in
        -n | --name) name=$2;;
    esac
    shift
done

if [ -z "${name+xxx}" ]
then
    echo "Error! Undefined project name."
    exit
fi

# create project tree structure
mkdir -p ${PWD}/${name}
mkdir -p ${PWD}/${name}/data
mkdir -p ${PWD}/${name}/docs
mkdir -p ${PWD}/${name}/src/tests/data

# __init__.py
touch ${PWD}/${name}/src/__init__.py
touch ${PWD}/${name}/src/tests/__init__.py

# .gitignore.py
touch ${PWD}/${name}/.gitignore
echo "*nc" > ${PWD}/${name}/.gitignore
echo "__pycache__" >> ${PWD}/${name}/.gitignore
echo ".env" >> ${PWD}/${name}/.gitignore
