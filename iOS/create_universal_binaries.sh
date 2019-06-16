cd "$( dirname "${BASH_SOURCE[0]}" )"
cd libs-iOS

OUTPUT_PATH=universal_binaries
mkdir -p "$OUTPUT_PATH"

lipo -create -output "$OUTPUT_PATH/libicutu.dylib" "arm64/libicutu.dylib" "armv7/libicutu.dylib" "x86_64/libicutu.dylib" "i386/libicutu.dylib"
lipo -create -output "$OUTPUT_PATH/libicudata.dylib" "arm64/libicudata.dylib" "armv7/libicudata.dylib" "x86_64/libicudata.dylib" "i386/libicudata.dylib"
lipo -create -output "$OUTPUT_PATH/libicui18n.dylib" "arm64/libicui18n.dylib" "armv7/libicui18n.dylib" "x86_64/libicui18n.dylib" "i386/libicui18n.dylib"
lipo -create -output "$OUTPUT_PATH/libicuio.dylib" "arm64/libicuio.dylib" "armv7/libicuio.dylib" "x86_64/libicuio.dylib" "i386/libicuio.dylib"
lipo -create -output "$OUTPUT_PATH/libicuuc.dylib" "arm64/libicuuc.dylib" "armv7/libicuuc.dylib" "x86_64/libicuuc.dylib" "i386/libicuuc.dylib"
