cd "$( dirname "${BASH_SOURCE[0]}" )"

PWD="$( dirname "${BASH_SOURCE[0]}" )"
BUILDPATH=build-$1
TOOLCHAIN=$1
#TOOLCHAIN=x86-linux-android
export NDK=$2

TOOLCHAIN_NAME=$TOOLCHAIN
if [ "$TOOLCHAIN" = "x86-linux-android" ]; then
    TOOLCHAIN_NAME=i686-linux-android
fi

rm -rf $TOOLCHAIN

$NDK/./build/tools/make-standalone-toolchain.sh --platform=android-23 --toolchain=$TOOLCHAIN --install-dir=$TOOLCHAIN

export PATH=$PATH:$(pwd)/$TOOLCHAIN/bin
export ANDROID_NDK_HOME=$(pwd)/$TOOLCHAIN

echo "Toolchain root:"
echo $(pwd)/$TOOLCHAIN/bin
echo "Toolchain name:"
echo $TOOLCHAIN_NAME

rm -rf $BUILDPATH
mkdir $BUILDPATH
cd $BUILDPATH

CROSS_PATH=$(pwd)/../build-host

echo "Toolchain name:"
echo $CROSS_PATH

~/Downloads/icu/source/configure --host=$TOOLCHAIN_NAME -with-cross-build=$CROSS_PATH  --enable-extras=yes --enable-strict=no --verbose CXXFLAGS='--std=c++11 -fPIC -frtti' LDFLAGS='-fPIC -g -DANDROID -fdata-sections -ffunction-sections -funwind-tables -fstack-protector-strong -no-canonical-prefixes -fno-addrsig'
#-fPIC -frtti' --enable-dyload=no
#--enable-static --enable-shared=no


gnumake VERBOSE=1 | tee output.txt

cd ..
mkdir libs-android
rm -rf ./libs-android/$TOOLCHAIN
./CreateJoinedLib $(pwd)/$BUILDPATH/output.txt
sh ./$BUILDPATH/build_libicu.sh
mv $BUILDPATH/lib ./libs-android/$TOOLCHAIN
rm -rf $BUILDPATH
rm -rf $TOOLCHAIN

sh ./fix_android_names.sh ./libs-android/$TOOLCHAIN 64 64.2
