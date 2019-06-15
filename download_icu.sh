rm -rf ~/Downloads/icu
rm -rf ~/Downloads/curl.tgz

curl -L https://github.com/unicode-org/icu/releases/download/release-64-2/icu4c-64_2-src.tgz --output ~/Downloads/curl.tgz
cd ~/Downloads
tar xopf ~/Downloads/curl.tgz

/bin/cp -f -R -p ~/Downloads/icu/source/tools/pkgdata/pkgdata.cpp ~/Downloads/icu/pkgdata_original.cpp
sed 's/system/0;\/\//g' ~/Downloads/icu/source/tools/pkgdata/pkgdata.cpp > ~/Downloads/icu/pkgdata_patched.cpp
