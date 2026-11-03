#!/usr/bin/env bash
set -euo pipefail
cmake -S . -B build ${CMAKE_ARGS} -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DBUILD_LIBRARY=ON -DBUILD_TESTS=ON -DBUILD_EXAMPLES=OFF -DBUILD_DOCUMENTATION=OFF
cmake --build build -j${CPU_COUNT}
( cd build && ctest --output-on-failure )
cmake --install build
