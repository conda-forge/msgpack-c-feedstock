#!/usr/bin/env python

"""
windows_fixup_cmake.py

Rewrite the CMake msgpackc configuration file to match the windows
library renaming done by the recipe bld.bat
"""

import sys
from pathlib import Path

cmake_target_file = Path(sys.argv[1])

print(f"Rewriting {cmake_target_file} for library renaming")

cmake_target_file.write_text(
    cmake_target_file.read_text()
    .replace("msgpack-c.lib", "msgpack-c_static.lib")
    .replace("msgpack-c_import.lib", "msgpack-c.lib")
)
