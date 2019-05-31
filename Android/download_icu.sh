rm -rf ~/Downloads/icu
rm -rf ~/Downloads/icu.tgz

curl -L https://github.com/unicode-org/icu/releases/download/release-64-2/icu4c-64_2-src.tgz --output ~/Downloads/curl.tgz
cd ~/Downloads
tar xopf ~/Downloads/curl.tgz

/bin/cp -f -R -p ~/Downloads/icu/source/tools/pkgdata/pkgdata.cpp ~/Downloads/icu/pkgdata_original.cpp
sed 's/system/0;\/\//g' ~/Downloads/icu/source/tools/pkgdata/pkgdata.cpp > ~/Downloads/icu/pkgdata_patched.cpp

if [ -z "$1" ] ;then
     echo "No myar.sh replacement"
else

sed 's/@RANLIB@/file/g' ~/Downloads/icu/source/icudefs.mk.in > ~/Downloads/icu/source/icudefs.mk.i_n
sed 's/@AR@/\~\/Downloads\/myar\.sh/g' ~/Downloads/icu/source/icudefs.mk.i_n > ~/Downloads/icu/source/icudefs.mk.in_
rm -rf ~/Downloads/icu/source/icudefs.mk.in
rm -rf ~/Downloads/icu/source/icudefs.mk.i_n
mv ~/Downloads/icu/source/icudefs.mk.in_ ~/Downloads/icu/source/icudefs.mk.in

fi
