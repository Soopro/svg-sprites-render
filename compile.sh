#!/bin/bash

if [ -d "build" ]
then
  rm -rf build
fi

coffee -c -o build src

if [ -d "dist" ]
then
  rm -rf dist
fi

mkdir dist
uglifyjs build/svg-sprites-render.js -m -p -o dist/svg-sprites-render.min.js

if [ -d "demo" ]
then
  cp build/svg-sprites-render.js demo/svg-sprites-render.js
fi