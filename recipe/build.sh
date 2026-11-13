#!/usr/bin/env bash
set -euo pipefail
# Learn and Net are on by default; they are listed so a missing dependency
# fails the build instead of silently dropping the component.
cmake -S . -B build ${CMAKE_ARGS} -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DBUILD_LIBRARY=ON -DBUILD_TESTS=ON -DBUILD_EXAMPLES=OFF -DBUILD_DOCUMENTATION=OFF \
      -DKALMAN_BUILD_LEARN=ON -DKALMAN_BUILD_NET=ON \
      -DKALMAN_USE_TORCH=ON -DKALMAN_USE_ONNXRUNTIME=ON \
      -DTorch_DIR=$PREFIX/share/cmake/Torch
cmake --build build -j${CPU_COUNT}
( cd build && ctest --output-on-failure )
cmake --install build
for lib in KalmanLearn KalmanNet; do
    test -f "$PREFIX/lib/lib${lib}${SHLIB_EXT}" || { echo "lib${lib} was not built"; exit 1; }
done
