#!/bin/bash

THREADS=`cat /proc/cpuinfo | grep processor | echo \`wc -l\``
CUR=`pwd`
BRANCH=master

# fetch sources
wget http://llvm.org/releases/3.4.2/llvm-3.4.2.src.tar.gz
tar xf llvm-3.4.2.src.tar.gz
rm llvm-3.4.2.src.tar.gz
mv llvm-3.4.2.src llvm
cd llvm/tools
wget http://llvm.org/releases/3.4.2/cfe-3.4.2.src.tar.gz
tar xf cfe-3.4.2.src.tar.gz
rm cfe-3.4.2.src.tar.gz
mv cfe-3.4.2.src clang
cd ${CUR}
git clone https://github.com/AnyDSL/thorin.git -b ${BRANCH}
git clone https://github.com/AnyDSL/impala.git -b ${BRANCH}

# create build/install dirs
mkdir -p llvm_build
mkdir -p llvm_install
mkdir -p thorin/build
mkdir -p impala/build

# build llvm
cd llvm_build
cmake ../llvm -DLLVM_REQUIRES_RTTI=true -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=${CUR}/llvm_install
make install -j${THREADS}

# build thorin
cd ${CUR}/thorin/build
cmake .. -DCMAKE_BUILD_TYPE=Debug -DLLVM_DIR=${CUR}/llvm_install/share/llvm/cmake
make -j${THREADS}

# build impala
cd ${CUR}/impala/build
cmake .. -DCMAKE_BUILD_TYPE=Debug -DLLVM_DIR=${CUR}/llvm_install/share/llvm/cmake -DTHORIN_DIR=${CUR}/thorin
make -j${THREADS}
export PATH=${CUR}/llvm_install/bin:${CUR}/impala/build/bin:$PATH

# go back to current dir
cd ${CUR}

echo
echo "put the following line into your '~/.bashrc' in order to have 'impala' in your path:"
echo "export PATH=${CUR}/llvm_install/bin:${CUR}/impala/build/bin:\$PATH"
