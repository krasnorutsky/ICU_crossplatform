cd "$( dirname "${BASH_SOURCE[0]}" )"
cd $1

mv libicu.so.*.* libicu.so

for l in *.so; do
  mv $l.*.* $l
  rm -rf $l.*
done

for l in *; do
  patchelf --set-soname "$l" "$l"
  for dep in $(patchelf --print-needed "$l"); do
    for f  in *; do
      case "$dep" in $f*)
        patchelf --replace-needed "$dep" "$f" "$l"
      esac
    done
  done
done
