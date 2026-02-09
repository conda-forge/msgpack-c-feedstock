
#!/usr/bin/env bash

mkdir build
cd build

# Check which output we're building
if [[ $PKG_NAME == "msgpack-c-static" ]]; then
    # Build static libraries for msgpack-c-static output
    cmake ${CMAKE_ARGS} \
        -GNinja \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=$PREFIX \
        -DBUILD_SHARED_LIBS=OFF \
        ..
    
    ninja install
    
    # Remove shared library files if they exist
    rm -f $PREFIX/lib/libmsgpack-c.so*
    rm -f $PREFIX/lib/libmsgpack-c.dylib*
    rm -f $PREFIX/lib/libmsgpack-c.dll
else
    # Build shared libraries for msgpack-c output
    cmake ${CMAKE_ARGS} \
        -GNinja \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=$PREFIX \
        -DBUILD_SHARED_LIBS=ON \
        ..
    
    ninja install
    if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
    ctest
    fi
    
    # Remove static library files if they exist
    rm -f $PREFIX/lib/libmsgpack-c.a
fi
