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
mkdir -p ${PWD}/${name}/tests/data
mkdir -p ${PWD}/${name}/src/${name}_pkg

# __init__.py
touch ${PWD}/${name}/src/${name}_pkg/__init__.py
touch ${PWD}/${name}/tests/__init__.py

# .gitignore.py
touch ${PWD}/${name}/.gitignore
echo "*nc" > ${PWD}/${name}/.gitignore
echo "__pycache__" >> ${PWD}/${name}/.gitignore
echo ".env" >> ${PWD}/${name}/.gitignore

# create virtual env, requirements.txt and update pip
python3 -m venv ${PWD}/${name}/env

touch ${PWD}/${name}/requirements_dev.txt
echo "flake8" >> ${PWD}/${name}/requirements_dev.txt
echo "black" >> ${PWD}/${name}/requirements_dev.txt
echo "isort" >> ${PWD}/${name}/requirements_dev.txt
echo "pytest" >> ${PWD}/${name}/requirements_dev.txt
echo "pytest-cov" >> ${PWD}/${name}/requirements_dev.txt
echo "mypy" >> ${PWD}/${name}/requirements_dev.txt
echo "tox" >> ${PWD}/${name}/requirements_dev.txt

touch ${PWD}/${name}/requirements.txt
echo "netCDF4" >> ${PWD}/${name}/requirements.txt
echo "numpy" >> ${PWD}/${name}/requirements.txt
echo "matplotlib" >> ${PWD}/${name}/requirements.txt
echo "geopandas" >> ${PWD}/${name}/requirements.txt
echo "descartes" >> ${PWD}/${name}/requirements.txt
echo "opencv-python" >> ${PWD}/${name}/requirements.txt

# create setup.cfg
touch ${PWD}/${name}/setup.cfg
echo " [metadata]
name = ${name}
description = <description>
author = Guillermo García-Sánchez
license = MIT
license_file = LICENSE
platforms = unix, linux, osx, cygwin, win32
classifiers =
    Programming Language :: Python :: 3
    Programming Language :: Python :: 3 :: Only
    Programming Language :: Python :: 3.6
    Programming Language :: Python :: 3.7
    Programming Language :: Python :: 3.8
    Programming Language :: Python :: 3.9

[options]
packages =
    ${name}_pkg
install_requires =
    netCDF4
    numpy
    matplotlib
    geopandas
    descartes
    opencv-python
python_requires = >=3.6
package_dir =
    =src
zip_safe = no

[options.extras_require]
testing =
    pytest>=6.0
    pytest-cov>=2.0
    mypy>=0.910
    flake8>=3.9
    tox>=3.24

[options.package_data]
slapping = py.typed

[flake8]
max-line-length = 160
" > ${PWD}/${name}/setup.cfg

# create setup.py
touch ${PWD}/${name}/setup.py
echo "from setuptools import setup
if __name__ == '__main__':
    setup()
" > ${PWD}/${name}/setup.py

# pyproject.toml
touch ${PWD}/${name}/pyproject.toml
echo "[build-system]
requires = ['setuptools>=42.0', 'wheel']
build-backend = 'setuptools.build_meta'

[tool.pytest.ini_options]
addopts = '--cov=.'
testpaths = [
    'tests',
]

[tool.mypy]
mypy_path = 'src'
check_untyped_defs = true
disallow_any_generics = true
ignore_missing_imports = true
no_implicit_optional = true
show_error_codes = true
strict_equality = true
warn_redundant_casts = true
warn_return_any = true
warn_unreachable = true
warn_unused_configs = true
no_implicit_reexport = true
" > ${PWD}/${name}/pyproject.toml

# create tox.ini
touch ${PWD}/${name}/tox.ini
echo " [tox]
minversion = 3.8.0
envlist = py36, py37, py38, py39, flake8, mypy
isolated_build = true

[gh-actions]
python =
    3.6: py36, mypy, flake8
    3.7: py37
    3.8: py38
    3.9: py39

[testenv]
setenv =
    PYTHONPATH = {toxinidir}
deps =
    -r{toxinidir}/requirements_dev.txt
commands =
    pytest --basetemp={envtmpdir}

[testenv:flake8]
basepython = python3.6
deps = flake8
commands = flake8 src tests

[testenv:mypy]
basepython = python3.6
deps =
    -r{toxinidir}/requirements_dev.txt
commands = mypy src
" > ${PWD}/${name}/tox.ini

touch ${PWD}/${name}/LICENSE
echo "MIT License

Copyright (c) 2021 Guillermo García-Sánchez

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
" > ${PWD}/${name}/LICENSE

${PWD}/${name}/env/bin/pip install --upgrade pip

${PWD}/${name}/env/bin/pip install -e ${PWD}/${name}

${PWD}/${name}/env/bin/black ${PWD}/${name}/*py
