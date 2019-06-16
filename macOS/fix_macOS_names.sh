cd "$( dirname "${BASH_SOURCE[0]}" )"
cd $1

echo "PWD = "$(pwd)

echo " "
echo "///// Setup identifiers for libraries"

install_name_tool -id libicudata.dylib libicudata.dylib
install_name_tool -id libicui18n.dylib libicui18n.dylib
install_name_tool -id libicuio.dylib libicuio.dylib
install_name_tool -id libicutu.dylib libicutu.dylib
install_name_tool -id libicuuc.dylib libicuuc.dylib

echo " "
echo "///// Edit dependancies"
for l in *; do
  for dep in $(otool -L $l); do
#find real files among verbose otool -L output
    if [ -f $dep ]; then
      for dep_idt in $(otool -D $dep); do
#find lib idt among verbose otool -D output
        if [ -f $dep_idt ]; then
          if [ $dep != $dep_idt ]; then
            echo "Change dependancy name $dep -> $dep_idt in $l"
            install_name_tool -change $dep @rpath/$dep_idt $l
          fi
        fi
      done
    fi
  done
done

echo " "
echo "///// Rename lib filenames to match their ids"
for l in *; do
#check existance of the file
  if [ -f $l ]; then
#check that the file is not a symlink
    readlink $l > /dev/null
    if [ $? != 0 ]; then
      for lib_idt in $(otool -D $l); do
#find lib idt among verbose otool -D output
        if [ -f $lib_idt ]; then
          if [ $l != $lib_idt ]; then
            if [ -f $lib_idt ]; then
              rm -f $lib_idt
              echo "Remove symlink $lib_idt"
            fi
            mv $l $lib_idt
            echo "Rename $l -> $lib_idt"
          fi
        fi
      done
    fi
  fi
done

echo " "
echo "///// Remove remaining symlinks"
for l in *; do
  readlink $l > /dev/null
  if [ $? == 0 ]; then
    rm -f $l
    echo "Remove symlink $l"
  fi
done

install_name_tool -id @rpath/libicudata.dylib libicudata.dylib
install_name_tool -id @rpath/libicui18n.dylib libicui18n.dylib
install_name_tool -id @rpath/libicuio.dylib libicuio.dylib
install_name_tool -id @rpath/libicutu.dylib libicutu.dylib
install_name_tool -id @rpath/libicuuc.dylib libicuuc.dylib
