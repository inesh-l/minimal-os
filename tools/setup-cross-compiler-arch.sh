# RUN WITH SUDO
export PREFIX="$(pwd)/tools/i386-cross-compiler"
export TARGET=i386-elf

mkdir tmp
mkdir tmp/source
cd tmp/source
curl -O http://ftp.gnu.org/gnu/binutils/binutils-2.39.tar.gz
tar xf binutils-2.39.tar.gz
mkdir binutils-build
cd binutils-build
../binutils-2.39/configure --target=$TARGET --enable-interwork --enable-multilib --disable-nls --disable-werror --prefix=$PREFIX 2>&1 | tee configure.log
make all install 2>&1 | tee make.log

cd tmp/source
curl -O https://ftp.gnu.org/gnu/gcc/gcc-12.2.0/gcc-12.2.0.tar.gz
tar xf gcc-12.2.0.tar.gz
mkdir gcc-build
cd gcc-build
echo Configure: . . . . . . .
../gcc-12.2.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --disable-libssp --enable-language=c,c++ --without-headers
echo MAKE ALL-GCC:
make all-gcc
echo MAKE ALL-TARGET-LIBGCC:
make all-target-libgcc
echo MAKE INSTALL-GCC:
make install-gcc
echo MAKE INSTALL-TARGET-LIBGCC:
make install-target-libgcc
echo BUILD COMPLETED