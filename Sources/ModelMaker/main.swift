import Foundation
import CommandLineKit
import Rainbow
import ModelMakerKit

let appVersion = "0.1.0"

#if os(Linux)
let EX_OK: Int32 = 0
let EX_USAGE: Int32 = 64
#endif

let cli = CommandLineKit.CommandLine()
cli.formatOutput = {s, type in
    var str: String
    switch(type) {
    case .error: str = s.red.bold
    case .optionFlag: str = s.green.underline
    default: str = s
    }

    return cli.defaultFormat(s: str, type: type)
}

let helpOption = BoolOption(shortFlag: "h", longFlag: "help", helpMessage: "Print this help message.")
cli.addOption(helpOption)

let versionOption = BoolOption(shortFlag: "v", longFlag: "version", helpMessage: "Print version.")

let jsonPathOption = StringOption(longFlag: "json", helpMessage: "Path of json file.")
cli.addOption(jsonPathOption)

let directoryOption = StringOption(shortFlag: "d", longFlag: "dir", helpMessage: "Directory to the output model files.")
cli.addOption(directoryOption)

let modelTypeOption = EnumOption<ModelType>(shortFlag: "t", longFlag: "model-type", helpMessage: "model type operation - o for Objective-C, s for Swift. Default is Swift.")
cli.addOption(modelTypeOption)

let prefixOption = StringOption(shortFlag: "p", longFlag: "prefix", helpMessage: "Set prefix for generated models. Default is nothing.")
cli.addOption(prefixOption)

let suffixOption = StringOption(shortFlag: "s", longFlag: "suffix", helpMessage: "Set suffix for generated models. Default is \"\(modelNameHelper.suffix)\".")
cli.addOption(suffixOption)

do {
    try cli.parse()
} catch {
    cli.printUsage(error)
    exit(EX_USAGE)
}

if !cli.unparsedArguments.isEmpty {
    print("Unknow arguments: \(cli.unparsedArguments)".red)
    cli.printUsage()
    exit(EX_USAGE)
}

//-----------开始根据输入的参数，处理各种情况------------

if helpOption.value {
    cli.printUsage()
    exit(EX_OK)
}

if versionOption.value {
    print(appVersion)
    exit(EX_OK)
}

if prefixOption.value != nil {
    modelNameHelper.prefix = prefixOption.value!
}

if suffixOption.value != nil {
    modelNameHelper.suffix = suffixOption.value!
}

let jsonPath = jsonPathOption.value ?? "."
let directory = directoryOption.value ?? "."

let modelType = modelTypeOption.value ?? .swift

if modelType == .objc {
    modelPropertyHelper.inheritFromJSONModel = inheritFromJSONModel()
}

print("Generating \(modelType.description) models... ⚙".bold)

do {
    try ModelMaker.createModels(from: jsonPath, to: directory, modelType: modelType).forEach({ (filePath) in
        print("\(filePath) is generated".green.bold)
    })
} catch {
    guard let e = error as? ModelMakerError else {
        print("Unknown Error: \(error)".red.bold)
        exit(EX_USAGE)
    }
    
    switch e {
    case .readFileFailed:
        print("Can't find json file at path: \(jsonPath)".red.bold)
    case .jsonFormatWrong:
        print("Oops, json format is wrong!".red.bold)
    case .writeFileFailed:
        print("Can't write file to the directory: \(directory)".red.bold)
    }
}




