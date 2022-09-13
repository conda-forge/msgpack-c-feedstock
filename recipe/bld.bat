mkdir build
cd build

SET GENERATOR=%CMAKE_GENERATOR%

IF "%ARCH%"=="32" (
    SET EXTRA_COMPILE_FLAGS=
) ELSE (
    SET EXTRA_COMPILE_FLAGS=/wd4267 /wd4244
)

IF "%VS_MAJOR%"=="9" (
    SET ENABLE_CXX11=NO
) ELSE (
    SET ENABLE_CXX11=YES
)

cmake ^
    -GNinja ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DCMAKE_CXX_FLAGS='"/D_VARIADIC_MAX=10 /EHsc %EXTRA_COMPILE_FLAGS%"' ^
    -DCMAKE_C_FLAGS="%COMPILE_FLAGS%" ^
    -DMSGPACK_CXX11=%ENABLE_CXX11% ^
    -DCMAKE_BUILD_TYPE=Release ^
    ..

ninja install

ctest
ctest --rerun-failed --output-on-failure


cd "%LIBRARY_PREFIX%/lib"
ren msgpackc.lib msgpackc_static.lib
ren msgpackc_import.lib msgpackc.lib

:: Handle this renaming in the generated CMake configuration
python "%RECIPE_DIR%\windows_fixup_cmake.py" ^
    "%LIBRARY_PREFIX%\lib\cmake\msgpack\msgpack-targets-release.cmake"
if %errorlevel% neq 0 exit /b %errorlevel%
