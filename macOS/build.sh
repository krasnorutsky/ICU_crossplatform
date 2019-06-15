cd "$( dirname "${BASH_SOURCE[0]}" )"

sh ./../copy_header_files.sh macOS

rm -rf build
mkdir -p build && cd build

/bin/cp -f -R -p ./../myar.sh ~/Downloads
sh ~/Downloads/icu/source/configure CXXFLAGS='--std=c++11' AR=~/Downloads/myar.sh RANLIB=file
gnumake

cd ..
rm -rf libs-macOS
mkdir libs-macOS
cp -R ./build/lib/* libs-macOS
sh ./fix_macOS_names.sh libs-macOS
