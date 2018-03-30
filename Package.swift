// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "ModelMaker",
    targets: [
        Target(name: "ModelMakerKit", dependencies: []),
        Target(name: "ModelMaker", dependencies: ["ModelMakerKit"])
    ],
    dependencies: [
        .Package(url: "https://github.com/jatoben/CommandLine", "3.0.0-pre1"),
		.Package(url: "https://github.com/onevcat/Rainbow", majorVersion:2),
        .Package(url: "https://github.com/kylef/PathKit.git", majorVersion: 0, minor: 8)
    ]
)
