cd "$( dirname "${BASH_SOURCE[0]}" )"
cd $1

VER_SHORT=$2
VER_FULL=$3

rm -rf libicu.so
rm -rf libicu.so.$VER_SHORT
mv libicu.so.$VER_FULL libicu.so
patchelf --set-soname libicu.so libicu.so
patchelf --replace-needed libicudata.so.$VER_SHORT libicudata.so libicu.so

rm -rf libicuuc.so
rm -rf libicuuc.so.$VER_SHORT
mv libicuuc.so.$VER_FULL libicuuc.so
patchelf --set-soname libicuuc.so libicuuc.so
patchelf --replace-needed libicudata.so.$VER_SHORT libicudata.so libicuuc.so

rm -rf libicui18n.so
rm -rf libicui18n.so.$VER_SHORT
mv libicui18n.so.$VER_FULL libicui18n.so
patchelf --set-soname libicui18n.so libicui18n.so
patchelf --replace-needed libicuuc.so.$VER_SHORT libicuuc.so libicui18n.so
patchelf --replace-needed libicudata.so.$VER_SHORT libicudata.so libicui18n.so

rm -rf libicudata.so
rm -rf libicudata.so.$VER_SHORT
mv libicudata.so.$VER_FULL libicudata.so
patchelf --set-soname libicudata.so libicudata.so

rm -rf libicuio.so
rm -rf libicuio.so.$VER_SHORT
mv libicuio.so.$VER_FULL libicuio.so
patchelf --set-soname libicuio.so libicuio.so
patchelf --replace-needed libicuuc.so.$VER_SHORT libicuuc.so libicuio.so
patchelf --replace-needed libicudata.so.$VER_SHORT libicudata.so libicuio.so
patchelf --replace-needed libicui18n.so.$VER_SHORT libicui18n.so libicuio.so

rm -rf libicutu.so
rm -rf libicutu.so.$VER_SHORT
mv libicutu.so.$VER_FULL libicutu.so
patchelf --set-soname libicutu.so libicutu.so
patchelf --replace-needed libicuuc.so.$VER_SHORT libicuuc.so libicutu.so
patchelf --replace-needed libicudata.so.$VER_SHORT libicudata.so libicutu.so
patchelf --replace-needed libicui18n.so.$VER_SHORT libicui18n.so libicutu.so
