cd "$( dirname "${BASH_SOURCE[0]}" )"

rm -rf build-host
mkdir -p build-host && cd build-host

sh ~/Downloads/icu/source/configure CXXFLAGS='--std=c++11'
gnumake

