mkdir build
cd build

SET GENERATOR=%CMAKE_GENERATOR%

IF "%ARCH%"=="32" (
    SET EXTRA_COMPILE_FLAGS=
) ELSE (
    SET EXTRA_COMPILE_FLAGS=/wd4267 /wd4244
)

cmake ^
    -GNinja ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DCMAKE_C_FLAGS="%COMPILE_FLAGS%" ^
    -DCMAKE_BUILD_TYPE=Release ^
    ..
if %errorlevel% neq 0 exit /b %errorlevel%

ninja install
if %errorlevel% neq 0 exit /b %errorlevel%

ctest
ctest --rerun-failed --output-on-failure
if %errorlevel% neq 0 exit /b %errorlevel%


cd "%LIBRARY_PREFIX%/lib"
ren msgpackc.lib msgpackc_static.lib
ren msgpackc_import.lib msgpackc.lib

:: Handle this renaming in the generated CMake configuration
python "%RECIPE_DIR%\windows_fixup_cmake.py" ^
    "%LIBRARY_PREFIX%\lib\cmake\msgpack\msgpack-targets-release.cmake"
if %errorlevel% neq 0 exit /b %errorlevel%
