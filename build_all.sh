cd "$( dirname "${BASH_SOURCE[0]}" )"

rm -rf build
mkdir build

sh ./download_icu.sh
sh ./copy_header_files.sh build
sh ./macOS/build.sh
mkdir ./build/libs-macOS
cp -R ./macOS/libs-macOS/* ./build/libs-macOS

sh ./Android/build.sh
mkdir ./build/libs-android
cp -R ./Android/libs-android/* ./build/libs-android
cp -R ./Android/ICUTest ./build

sh ./iOS/build.sh
mkdir ./build/libs-iOS
cp -R ./iOS/libs-iOS/* ./build/libs-iOS
cp -R ./iOS/ICUTestIOS ./build
