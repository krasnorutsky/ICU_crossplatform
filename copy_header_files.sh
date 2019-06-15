cd "$( dirname "${BASH_SOURCE[0]}" )"
cd $1

rm -rf ./include
mkdir ./include
mkdir ./include/unicode
cp -R ~/Downloads/icu/source/*/unicode/* ./include/unicode
