#!/bin/sh

DIR="$(dirname "$(realpath "$0")")"

rm -rf "$DIR/exports"
mkdir "$DIR/exports"
mkdir "$DIR/exports/android"
mkdir "$DIR/exports/web"
mkdir "$DIR/exports/macos"
mkdir "$DIR/exports/windows"
mkdir "$DIR/exports/linux"
