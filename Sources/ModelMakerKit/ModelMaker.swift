//
//  ModelMaker.swift
//  ModelMakerKit
//
//  Created by 张楠 on 2017/11/29.
//

import Foundation
import PathKit

// MARK: Json Tree
class Node: NSObject {
    var name: String = ""
    var type: String = ""
    var childs: [Node] = []
    var level: Int = 0
    
    func createChildNodes(withDict data: [String: Any]) {}
}

extension Node {
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}

class SwiftNode: Node {
    override func createChildNodes(withDict data: [String: Any]) {
        
        for key in data.keys {
            let node = SwiftNode(name: key)
            node.level = self.level + 1
            
            let value = data[key]
            if value is String {
                node.type = SwiftBasePropertyType.kString.rawValue
            } else if value is Int {
                node.type = SwiftBasePropertyType.kInt.rawValue
            } else if value is Float {
                node.type = SwiftBasePropertyType.kFloat.rawValue
            } else if value is Bool {
                node.type = SwiftBasePropertyType.kBool.rawValue
            } else if value is [String: Any] {
                node.type = modelNameHelper.generateName(with: key)
                node.createChildNodes(withDict: value as! [String: Any])
            } else if value is [String] {
                if let array = value as? [String], array.count > 0 {
                    node.type = SwiftBasePropertyType.kStringArray.rawValue
                } else {
                    node.type = modelPropertyHelper.unknowType
                }
            } else if value is [Int] {
                node.type = SwiftBasePropertyType.kIntArray.rawValue
            } else if value is [Float] {
                node.type = SwiftBasePropertyType.kFloatArray.rawValue
            } else if value is [Bool] {
                node.type = SwiftBasePropertyType.kBool.rawValue
            } else if value is [[String: Any]] {
                node.type = SwiftBasePropertyType.customArrayPropertyType(with: key)
                if let customModelArray = value as? [[String: Any]], customModelArray.count > 0{
                    node.createChildNodes(withDict: customModelArray[0])
                }
            } else {
                node.type = modelPropertyHelper.unknowType
            }
            
            self.childs.append(node)
        }
    }
}

class ObjCNode: Node {
    override func createChildNodes(withDict data: [String: Any]) {
        
        for key in data.keys {
            let node = ObjCNode(name: key)
            node.level = self.level + 1
            
            let value = data[key]
            if value is String {
                node.type = modelPropertyHelper.objcString
            } else if value is Int || value is Float || value is Bool {
                node.type = modelPropertyHelper.objcNumber
            } else if value is [String] {
                node.type = modelPropertyHelper.objcStringArray
            } else if value is [Int] || value is [Float] || value is [Bool] {
                node.type = modelPropertyHelper.objcNumberArray
            } else if value is [String: Any] {
                node.type = modelPropertyHelper.objcCustomType(with: key)
                node.createChildNodes(withDict: value as! [String: Any])
            } else if value is [[String: Any]] {
                node.type = modelPropertyHelper.objcCustomArrayType(with: key)
                if let customModelArray = value as? [[String: Any]], customModelArray.count > 0{
                    node.createChildNodes(withDict: customModelArray[0])
                }
            } else {
                node.type = modelPropertyHelper.unknowType
            }
            
            self.childs.append(node)
        }
        
    }
}

struct Tree {
    let rootNode: Node
    //(跟在数据结构书里看到的有什么不同呢，给到的json本身就是树状结构了，所以在构造时不需要找怎么插入孩子节点)
    static func createTree(withDict data: [String: Any], rootNodeName: String, type: ModelType) -> Tree {
        var node: Node
        switch type {
        case .objc:
            node = ObjCNode(name: rootNodeName)
        case .swift:
            node = SwiftNode(name: rootNodeName)
        }
        
        node.level = 0
        node.type = modelNameHelper.generateName(with: rootNodeName)
        node.createChildNodes(withDict: data)
        
        return Tree(rootNode: node)
    }
    
    //拿到该树下的所有非叶子节点
    var allSubNodes: [Node] {
        guard rootNode.childs.count > 0 else {
            return[];
        }
        
        var results: [Node] = []
        
        var queue = [rootNode]
        
        var node: Node
        
        while queue.count > 0 {
            node = queue.removeFirst()
            if node.childs.count > 0 {
                results.append(node)
                queue.append(contentsOf: node.childs)
            }
        }
        
        return results
    }
}

// MARK: Create File

//负责创建单独的文件
class ModelFile: NSObject {
    let node: Node
    
    var modelSwiftTotalFileString: String
    var modelObjCHeaderFileString: String
    var modelObjCMFileString: String
    
    let directory: String
    
    init(node: Node, directory: String) {
        self.node = node
        self.modelSwiftTotalFileString = modelFileFormatDict["SwiftTotalFile"]!
        self.modelObjCHeaderFileString = modelFileFormatDict["modelHeaderFileString"]!
        self.modelObjCMFileString = modelFileFormatDict["modelMFileString"]!
        self.directory = directory
    }
    
    func createSwiftFile() throws -> String {
        let fileName = SwiftBasePropertyType.getClassType(with: node.type)
        
        //替换文件名
        modelSwiftTotalFileString = modelSwiftTotalFileString.replacingOccurrences(of: "[Swift-Model-Name]", with: fileName)
        
        //替换项目相关信息
        modelSwiftTotalFileString = modelSwiftTotalFileString.replacingOccurrences(of: "[Swift-Author]", with: projectInfo.author)
        modelSwiftTotalFileString = modelSwiftTotalFileString.replacingOccurrences(of: "[Swift-Date]", with: projectInfo.dateString)
        modelSwiftTotalFileString = modelSwiftTotalFileString.replacingOccurrences(of: "[Swift-Year]", with: projectInfo.yearString)
        
        //替换属性
        var propertiesString = ""
        node.childs.forEach { (node) in
            let tmpString = "   let \(node.name): \(node.type)\n"
            propertiesString = propertiesString.appending(tmpString)
        }
        
        modelSwiftTotalFileString = modelSwiftTotalFileString.replacingOccurrences(of: "[Swift-Stored-Property]", with: propertiesString)
        
        //写入到文件中
        let swiftFilePath = directory + "/\(fileName).swift"
        let path = Path(swiftFilePath)
        do {
            try path.write(modelSwiftTotalFileString)
        } catch {
            throw ModelMakerError.writeFileFailed
        }
        
        return swiftFilePath
    }
    
    func createObjectiveCFile() throws -> [String] {
        let fileName = modelPropertyHelper.getObjcClassType(with: node.type)
        
        //替换文件名
        modelObjCHeaderFileString = modelObjCHeaderFileString.replacingOccurrences(of: "[ObjC-Model-Name]", with: fileName)
        
        modelObjCMFileString = modelObjCMFileString.replacingOccurrences(of: "[ObjC-Model-Name]", with: fileName)
        
        //替换项目相关信息
        modelObjCHeaderFileString = modelObjCHeaderFileString.replacingOccurrences(of: "[ObjC-Author]", with: projectInfo.author)
        modelObjCHeaderFileString = modelObjCHeaderFileString.replacingOccurrences(of: "[ObjC-Date]", with: projectInfo.dateString)
        modelObjCHeaderFileString = modelObjCHeaderFileString.replacingOccurrences(of: "[ObjC-Year]", with: projectInfo.yearString)
        
        modelObjCMFileString = modelObjCMFileString.replacingOccurrences(of: "[ObjC-Author]", with: projectInfo.author)
        modelObjCMFileString = modelObjCMFileString.replacingOccurrences(of: "[ObjC-Date]", with: projectInfo.dateString)
        modelObjCMFileString = modelObjCMFileString.replacingOccurrences(of: "[ObjC-Year]", with: projectInfo.yearString)
        
        //用@class声明自定义类
        var declareClassString = ""
        var importClassString = ""
        node.childs.forEach { (node) in
            if !modelPropertyHelper.isObjcBaseType(propertyType: node.type) {
                let classType = modelPropertyHelper.getObjcClassType(with: node.type)
                var tmpString = ""
                if declareClassString == "" {
                    tmpString = "@class \(classType)"
                } else {
                    tmpString = ", \(classType)"
                }
                declareClassString = declareClassString.appending(tmpString)
                importClassString = importClassString.appending("#import \"\(classType).h\"\n")
            }
        }
        if declareClassString != "" {
            declareClassString = declareClassString.appending(";\n")
        }
        if importClassString != "" {
            importClassString = importClassString.appending("\r")
        }
        
        modelObjCHeaderFileString = modelObjCHeaderFileString.replacingOccurrences(of: "[ObjC-Declare-Class]", with: declareClassString)
        modelObjCMFileString = modelObjCMFileString.replacingOccurrences(of: "[Objc-Import-Class]", with: importClassString)
        
        //替换属性
        var propertiesString = ""
        node.childs.forEach { (node) in
            var tmpString = ""
            if node.type == modelPropertyHelper.objcString {
                tmpString = "@property (nonatomic, copy) \(node.type)\(node.name);\n"
            } else {
                tmpString = "@property (nonatomic, strong) \(node.type)\(node.name);\n"
            }
            
            propertiesString = propertiesString.appending(tmpString)
        }
        
        modelObjCHeaderFileString = modelObjCHeaderFileString.replacingOccurrences(of: "[ObjC-Stored-Property]", with: propertiesString)
        
        //写入到文件中
        let objcHeaderFilePath = directory + "/\(fileName).h"
        let headerPath = Path(objcHeaderFilePath)
        let objcMFilePath = directory + "/\(fileName).m"
        let mPath = Path(objcMFilePath)
        do {
            try headerPath.write(modelObjCHeaderFileString)
            try mPath.write(modelObjCMFileString)
        } catch {
            throw ModelMakerError.writeFileFailed
        }
        
        return [objcHeaderFilePath, objcMFilePath]
    }
}

// MARK: ModelMaker

public struct ModelMaker {
    
    public init(){}
    
    public static func readJsonFile(_ filePath: String) throws -> [String: Any] {
        let p = Path(filePath)
        
        guard let data = try? p.read() else {
            throw ModelMakerError.readFileFailed
        }
        
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        
        guard let dict = json as? [String: Any] else {
            throw ModelMakerError.jsonFormatWrong
        }
        
        return dict
    }
    
    public static func openFile(_ filePath: String) {
        let process = Process()
        process.launchPath = "/usr/bin/env"
        process.arguments = ["open", filePath]
        process.launch()
    }
    
    //要返回生成的文件路径和错误
    public static func createModels(from jsonFile: String, to directory: String, modelType: ModelType) throws -> [String] {
        
        var createdFiles = [String]()
        
        let json = try readJsonFile(jsonFile)
        
        let tree = Tree.createTree(withDict: json, rootNodeName: "Root", type: modelType)
        
        for node in tree.allSubNodes {
            let modelFile = ModelFile(node: node, directory: directory)
            switch(modelType) {
            case .objc:
                let filePath = try modelFile.createObjectiveCFile()
                createdFiles.append(contentsOf: filePath)
            case .swift:
                let swiftPath = try modelFile.createSwiftFile()
                createdFiles.append(swiftPath)
            }
        }
        
        openFile(directory)
        
        return createdFiles
    }
}

