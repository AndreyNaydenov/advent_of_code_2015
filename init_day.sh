#!/bin/bash
#set -x # uncomment for debug

# take one arg (day number)
# create directory inside src/ with name day<daynum>
# add to that dir:
# 1. empty file "input.txt"
# 2. template "main.zig" (some basic imports and main function)

# check that arg is valid
if [ -z "$1" ] || [ ${#1} -gt 2 ] || ! [ "$1" -eq "$1" ] 2>/dev/null; then
  echo "Usage: $0 <day_number>
    day_number: number from 1 to 25"
  exit 1
fi

# cd to script directory if script is called from other place
SCRIPT_DIR=$(dirname "$(realpath "$BASH_SOURCE")")
cd $SCRIPT_DIR

formatted_num=$(printf "%02d" "$1")

cd src

dir_name="day$formatted_num"

# check if dir for that day already exists
if [ -d "$dir_name" ]; then
  echo "Dir $dir_name already exists"
  exit 1
fi

mkdir -p $dir_name

cd $dir_name

touch input.txt

cp ../../template_main.zig main.zig
