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

if [ -d "${PWD}/${name}" ]
then
    echo "Project name exists."
    echo "......."
    echo "Aborting"
    exit -1
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
echo "env/" >> ${PWD}/${name}/.gitignore

# create virtual env, requirements.txt and update pip
python3 -m venv ${PWD}/${name}/env

touch ${PWD}/${name}/requirements.txt
echo "flake8===3.8.4" > ${PWD}/${name}/requirements.txt
echo "black==20.8b1" >> ${PWD}/${name}/requirements.txt
echo "isort==5.6.4" >> ${PWD}/${name}/requirements.txt
echo "pytest==6.1.2" >> ${PWD}/${name}/requirements.txt
echo "pytest-cov==2.10.1" >> ${PWD}/${name}/requirements.txt

${PWD}/${name}/env/bin/pip install --upgrade pip

${PWD}/${name}/env/bin/pip install -r ${PWD}/${name}/requirements.txt
