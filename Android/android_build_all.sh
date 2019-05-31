cd "$( dirname "${BASH_SOURCE[0]}" )"

NDK=~/Library/Android/sdk/ndk-bundle
sh ./sub_android_compile.sh x86-linux-android $NDK
sh ./sub_android_compile.sh x86_64-linux-android $NDK
sh ./sub_android_compile.sh arm-linux-androideabi $NDK
sh ./sub_android_compile.sh aarch64-linux-android $NDK
