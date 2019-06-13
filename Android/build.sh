cd "$( dirname "${BASH_SOURCE[0]}" )"

brew --version

if [ $? != 0 ]; then
echo "Homebrew is not installed. It is necessary to proceed. Install it and try again."
exit 1
fi

patchelf --version

if [ $? != 0 ]; then
echo "patchelf is not installed. It is necessary to proceed. Install it via Homebrew and try again."
exit 2
fi

STANDALONE_EXPORT_FILE=~/Library/Android/sdk/ndk-bundle/build/tools/make-standalone-toolchain.sh
if [ -f "$STANDALONE_EXPORT_FILE" ]; then
echo "NDK is installed"
else
echo "Android NDK not found. It must be installed to the default location: ~/Library/Android/sdk/ndk-bundle . Aborting..."
exit 3
fi

#TODO move to download_icu.sh
/bin/cp -f -R -p ./myar.sh ~/Downloads

sh ./download_icu.sh "REPLACE AR AND RANLIB"
sh ./build_host.sh
sh ./download_icu.sh
sh ./android_build_all.sh
