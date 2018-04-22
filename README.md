# ModelMaker

<p align="center">
<a href="https://travis-ci.org/shinancao/ModelMaker"><img src="https://img.shields.io/travis/shinancao/ModelMaker/master.svg"></a>
<a href="https://swift.org/package-manager/"><img src="https://img.shields.io/badge/swift-4.0-brightgreen.svg"/></a>
<a href="https://swift.org/package-manager/"><img src="https://img.shields.io/badge/SPM-ready-orange.svg"></a>
<a href="https://swift.org/package-manager/"><img src="https://img.shields.io/badge/platform-macos%20|%20Linux-blue.svg"/></a>
</p>

This is a command-line util to generate Swift and Objective-C models from json files.

## Features

* Generate Swift models from json files.
* Generate Objective-C models from json files, and specify generic in the array.
* If you use `JSONModel`, the generated models will inherit from `JSONModel`, only for Objective-C models.
* You can specify prefix and suffix for models.
* As a command-line, it is convenient to use.

## Getting Started

### Install

You need Swift Package Manager (as well as swift compiler) installed in your macOS, generally you are prepared if you have the latest Xcode installed.

### Compile from source

```bash
> git clone https://github.com/shinancao/ModelMaker.git
> cd ModelMaker
> ./install.sh
```

ModelMaker will be compiled and installed into the `/usr/local/bin`.

### Usage

Open your terminal and run:

```bash
> modelmaker --json /Users/Shinancao/Desktop/test.json -d /Users/Shinancao/Desktop/modelFiles -t o
```
Please replace the params with yours.

ModelMaker supports some arguments, you could find it by:

```shell
> modelmaker -h
  -h, --help:
      Print this help message.
  --json:
      Path of json file.
  -d, --dir:
      Directory to the output model files.
  -t, --model-type:
      model type operation - o for Objective-C, s for Swift. Default is Swift.
  -p, --prefix:
      Set prefix for generated models. Default is nothing.
  -s, --suffix:
      Set suffix for generated models. Default is "Model".
```

## How Tt Works



## Other Things

