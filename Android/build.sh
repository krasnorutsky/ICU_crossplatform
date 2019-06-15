cd "$( dirname "${BASH_SOURCE[0]}" )"

brew --version

if [ $? != 0 ]; then
echo "Homebrew is not installed. It is necessary to build android libs. Install it and try again."
exit 1
fi

patchelf --version

if [ $? != 0 ]; then
echo "patchelf is not installed. It is necessary to build android libs. Install it via Homebrew and try again."
exit 2
fi

STANDALONE_EXPORT_FILE=~/Library/Android/sdk/ndk-bundle/build/tools/make-standalone-toolchain.sh
if [ -f "$STANDALONE_EXPORT_FILE" ]; then
echo "NDK is installed"
else
echo "Android NDK not found. It must be installed to the default location: ~/Library/Android/sdk/ndk-bundle . Aborting..."
exit 3
fi

sh ./../copy_header_files.sh Android

NDK=~/Library/Android/sdk/ndk-bundle
sh ./sub_android_compile.sh x86-linux-android $NDK
sh ./sub_android_compile.sh x86_64-linux-android $NDK
sh ./sub_android_compile.sh arm-linux-androideabi $NDK
sh ./sub_android_compile.sh aarch64-linux-android $NDK
