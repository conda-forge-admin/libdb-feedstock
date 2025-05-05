#!/bin/bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* ./dist
cp $BUILD_PREFIX/share/gnuconfig/config.* ./lang/sql/odbc
cp $BUILD_PREFIX/share/gnuconfig/config.* ./lang/sql/jdbc
cp $BUILD_PREFIX/share/gnuconfig/config.* ./lang/sql/sqlite
cp $BUILD_PREFIX/share/gnuconfig/config.* ./lang/sql/sqlite/autoconf

# docdir specified to avoid installation of 100MB of extracted docs
cd build_unix
../dist/configure --prefix=$PREFIX \
                  --docdir="$(pwd)/do_not_install_the_docs/docs" \
                  --enable-shared \
                  --disable-static \
                  --enable-cxx \
                  --enable-stl

make -j$CPU_COUNT
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
    make check -j$CPU_COUNT
fi
make install -j$CPU_COUNT
