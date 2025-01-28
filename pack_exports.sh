#!/bin/sh

DIR="$(dirname "$(realpath "$0")")"

echo "Packing"
cd "$DIR/exports"

find "." -maxdepth 1 -type d -not -path "." -print0 | 
  while IFS= read -r -d $'\0' d; do
    base=$(basename "$d")
    echo "Creating archive: $base.tar.gz"
    tar -czvf "bobapop-$base.tar.gz" "$base" && echo "Done packing $base." || echo "Failed packing $base!";
  done

echo "Creating complete tar"
find "." -maxdepth 1 -type d -not -path "." -print0 | 
  tar -czvf "bobapop-all.tar.gz" --null -T -

echo "Everything packed."
exit 0
