cd "$( dirname "${BASH_SOURCE[0]}" )"

sh ./../copy_header_files.sh iOS

sh ./sub_iOS_compile.sh i386 i686-apple-darwin
sh ./sub_iOS_compile.sh x86_64 i686-apple-darwin
sh ./sub_iOS_compile.sh armv7 arm-apple-darwin
sh ./sub_iOS_compile.sh arm64 arm-apple-darwin

sh ./create_universal_binaries.sh
