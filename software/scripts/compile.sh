#!/bin/bash

BUILD=$PWD/build
cd $BUILD

# Compile all the modules:
for MOD in $PWD/../modules/*; do
	$MOD compile
done

cd ..

