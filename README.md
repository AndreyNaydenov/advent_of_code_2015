# Advent of Code 2015 in Zig

## Usage:
1. Use init_day.sh to init solution directory in src/
2. Put your task input to src/dayXX/input.txt
3. Write your code solutions in src/dayXX/main.zig
4. Build and run (see [Build](#build))

## Build:
To build all days run ```zig build --summary all```  
Arg `run` can be added, to also run all compiled solutions

## TODO:

- ~~init_day.sh script to create default day dir layout~~
- init_day.sh change all path to be relative to script, not cwd
- ~~build.zig that iterates over all day dirs, compiles and runs solutions~~
- build option `-Dnumber=<daynum>` to compile and run single day
- day1 solution
- ~~what is the best way to read an input? (I choose @embedFile)~~
- build option `-Dexample=<examplenum>` that shows that we need to use example input with some number instead of main input
