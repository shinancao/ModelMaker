#!/bin/sh
swift package clean
swift build -c release
cp .build/release/ModelMaker /usr/local/bin/modelmaker
