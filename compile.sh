#!/bin/bash

coffee -c -o . src

uglifyjs svg-sprites-render.js -m -p -o svg-sprites-render.min.js

if [ -d "demo" ]
then
  cp build/svg-sprites-render.js demo/svg-sprites-render.js
fi