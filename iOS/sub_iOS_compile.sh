cd "$( dirname "${BASH_SOURCE[0]}" )"

PWD="$( dirname "${BASH_SOURCE[0]}" )"
ARCH=$1
HOST=$2
BUILDPATH=build-$ARCH

DEVELOPER="$(xcode-select --print-path)"
SDKROOT="$(xcodebuild -version -sdk iphoneos | grep -E '^Path' | sed 's/Path: //')"

ICU_PATH="~/Downloads/icu"
ICU_FLAGS="-I$ICU_PATH/source/common/ -I$ICU_PATH/source/tools/tzcode/ "

export CXX="$DEVELOPER/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++"
export CC="$DEVELOPER/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang"
export CFLAGS="-isysroot $SDKROOT -I$SDKROOT/usr/include/ -I./include/ -arch $ARCH -miphoneos-version-min=7.0 $ICU_FLAGS"
export CXXFLAGS="-stdlib=libc++ -std=c++11 -isysroot $SDKROOT -I$SDKROOT/usr/include/ -I./include/ -arch $ARCH -miphoneos-version-min=7.0 $ICU_FLAGS"
export LDFLAGS="-stdlib=libc++ -L$SDKROOT/usr/lib/ -isysroot $SDKROOT -Wl,-dead_strip -miphoneos-version-min=7.0 -lstdc++"

mkdir -p $BUILDPATH && cd $BUILDPATH

[ -e Makefile ] && make distclean

/bin/cp -f -R -p ./../../macOS/myar.sh ~/Downloads
~/Downloads/icu/source/configure --host=$HOST -with-cross-build=$(pwd)/../../macOS/build AR=~/Downloads/myar.sh RANLIB=file

rm -rf ~/Downloads/icu/source/tools/pkgdata/pkgdata.cpp
/bin/cp -f -R -p ~/Downloads/icu/pkgdata_patched.cpp ~/Downloads/icu/source/tools/pkgdata/pkgdata.cpp
gnumake
rm -rf ~/Downloads/icu/source/tools/pkgdata/pkgdata.cpp
/bin/cp -f -R -p ~/Downloads/icu/pkgdata_original.cpp ~/Downloads/icu/source/tools/pkgdata/pkgdata.cpp

cd ..
mkdir libs-iOS
rm -rf ./libs-iOS/$ARCH
mkdir ./libs-iOS/$ARCH
cp -R $BUILDPATH/lib/* ./libs-iOS/$ARCH

sh ./../macOS/fix_macOS_names.sh ./../iOS/libs-iOS/$ARCH
