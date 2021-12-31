#!/bin/bash

while [ $# -gt 0 ] ; do
    case $1 in
        -n | --name) name=$2;;
    esac
    shift
done

workdir="${PWD}/${name}"

if [ -z "${name+xxx}" ]
then
    echo "Error! Undefined fortran program name."
    exit -1
fi

if [ -d "${workdir}" ]
then
    echo "Fortran project name has already exists."
    echo "......."
    echo "Aborting"
    exit -1
fi


# create project tree structure
mkdir -p ${workdir}
mkdir -p ${workdir}/data
mkdir -p ${workdir}/docs
mkdir -p ${workdir}/tests/data
mkdir -p ${workdir}/src/${name}_pkg

touch ${workdir}/main.f95
echo "
program main
    use precision
    implicit none

	real(dp) :: example = 0.1

    print *, example

end program main
" > ${workdir}/main.f95


touch ${workdir}/precision.f95
echo "
module precision
    use iso_fortran_env, only:  int8, int16, int32, int64, real32, real64, &
                                input_unit, output_unit, error_unit
    implicit none
    integer, parameter :: sp        = real32
    integer, parameter :: dp        = real64
    integer, parameter :: stdin     = input_unit
    integer, parameter :: stdout    = output_unit
    integer, parameter :: stderr    = error_unit
end module
" > ${workdir}/precision.f95

touch ${workdir}/constants.f95
echo "
module constants
    use precision
    implicit none

    real(kind = dp) :: example = 0.0
    
end module constants
" > ${workdir}/constants.f95


echo " ===== DONE ===== "
