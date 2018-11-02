#!/bin/bash

cd ../fortran/build_help
ifort -o sizes -qopenmp omp_sizes.f90
python sub_sizes.py

cd ..
ifort ompgen.F90 -qopenmp -fpp -save-temps > /dev/null 2>&1
mv ompgen.i90 omp.f90
f2py *.f90 -m _wrffortran -h wrffortran.pyf --overwrite-signature
cd ..

python setup.py clean --all
python setup.py config_fc --fcompiler=intelem --f90flags="-xHost -mkl" build_ext --rpath="/apps/cent7/intel/compilers_and_libraries/linux/lib/intel64_lin:/apps/cent7/intel/compilers_and_libraries/linux/mkl/lib/intel64_lin" --library-dirs="/apps/cent7/intel/compilers_and_libraries/linux/lib/intel64_lin:/apps/cent7/intel/compilers_and_libraries/linux/mkl/lib/intel64_lin" --libraries="mkl_intel_ilp64 mkl_intel_thread mkl_core iomp5 pthread m dl" build --compiler=intelem --fcompiler=intelem bdist_wheel

pip install .

