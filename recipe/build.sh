
#!/usr/bin/env bash

mkdir build
cd build

cmake \
    -GNinja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DMSGPACK_CXX11=YES \
    ${CMAKE_ARGS} \
    ..

ninja install

if [[ "$CONDA_BUILD_CROSS_COMPILATION" != "1" ]]; then
  ctest
fi

