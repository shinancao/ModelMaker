import Foundation
import CommandLineKit
import Rainbow
import ModelMakerKit

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

let jsonPathOption = StringOption(longFlag: "json", required: true, helpMessage: "Path of json file.")
cli.addOption(jsonPathOption)

let directoryOption = StringOption(shortFlag: "d", longFlag: "dir", required: true, helpMessage: "Directory to the output model files.")
cli.addOption(directoryOption)

let helpOption = BoolOption(shortFlag: "h", longFlag: "help", helpMessage: "Print this help message.")
cli.addOption(helpOption)

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

if prefixOption.value != nil {
    modelNameHelper.prefix = prefixOption.value!
}

if suffixOption.value != nil {
    modelNameHelper.suffix = suffixOption.value!
}

let jsonPath = jsonPathOption.value ?? "."
let directory = directoryOption.value ?? "."

let modelType = modelTypeOption.value ?? .swift

print("Generating \(modelType.description) models... ⚙".bold)

let modelMaker = ModelMaker()
modelMaker.createModels(from: jsonPath, to: directory, modelType: modelType).forEach { (file) in
    print("\(file) is generated".green.bold)
}




