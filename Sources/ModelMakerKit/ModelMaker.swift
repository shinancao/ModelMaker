//
//  ModelMaker.swift
//  ModelMakerKit
//
//  Created by 张楠 on 2017/11/29.
//

import Foundation
import PathKit

struct Node {
    var name: String   //属性的名字
    var type: String   //属性的类型
    var childs: [Node] //该node下的所有子节点，亦即所有属性
    var level: Int     //该node所在的层
    
    init(name: String) {
        self.name = name
        self.type = ""
        self.childs = []
        self.level = 0
    }
    
    mutating func createChildNodes(withDict data: [String: Any]) {
    
        for key in data.keys {
            var node = Node(name: key)
            node.level = self.level + 1
            
            let value = data[key]
            if value is String {
                node.type = "String"
            } else if value is Int {
                node.type = "Int"
            } else if value is Float {
                node.type = "Float"
            } else if value is Bool {
                node.type = "Bool"
            } else if value is [String: Any] {
                node.type = modelNameHelper.generateName(with: key)
                node.createChildNodes(withDict: value as! [String: Any])
            } else if value is [String] {
                if let array = value as? [String], array.count > 0 {
                    node.type = "[String]"
                } else {
                    node.type = "[]"
                }
            } else if value is [Int] {
                node.type = "[Int]"
            } else if value is [Float] {
                node.type = "[Float]"
            } else if value is [Bool] {
                node.type = "[Bool]"
            } else if value is [[String: Any]] {
                node.type = "[\(modelNameHelper.generateName(with: key))]"
                if let customModelArray = value as? [[String: Any]], customModelArray.count > 0{
                    node.createChildNodes(withDict: customModelArray[0])
                }
            } else {
                node.type = "\"unknown type\""
            }
            
            self.childs.append(node)
        }
    }
}

struct Tree {
    let rootNode: Node
    //(跟在数据结构书里看到的有什么不同呢，给到的json本身就是树装结构了，所以在构造时不需要找怎么插入孩子节点)
    static func createTree(withDict data: [String: Any], rootNodeName: String) -> Tree {
        var node = Node(name: rootNodeName)
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

//负责创建单独的文件
class ModelFile: NSObject {
    let node: Node
    
    var modelSwiftTotalFileString: String
    
    init(node: Node) {
        self.node = node
        self.modelSwiftTotalFileString = modelFileFormatDict["SwiftTotalFile"]!
    }
    
    func createSwiftFile(to directory: String) throws -> String {
        //替换文件名
        let fileName = node.type.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
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
        
        let swiftFilePath = directory + "/\(fileName).swift"
        let path = Path(swiftFilePath)
        //写入到文件中
        do {
            try path.write(modelSwiftTotalFileString)
            return swiftFilePath
        } catch {
            throw ModelMakerError.createFileFailed
        }
    }
}

public struct ModelMaker {
    
    public init(){}
    
    func readJsonFile(_ filePath: String) throws -> [String: Any] {
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
    
    func openFile(_ filePath: String) {
        let process = Process()
        process.launchPath = "/usr/bin/env"
        process.arguments = ["open", filePath]
        process.launch()
    }
    
    //要返回生成的文件路径和错误
    public func createModels(from jsonFile: String, to directory: String, modelType: ModelType) -> [String] {
        var createdFiles = [String]()
        do {
            let json = try readJsonFile(jsonFile)
            let tree = Tree.createTree(withDict: json, rootNodeName: "Test")
            for node in tree.allSubNodes {
                do {
                    let modelFile = ModelFile(node: node)
                    //后面考虑到Objective-C的要改
                    let filePath = try modelFile.createSwiftFile(to: directory)
                    createdFiles.append(filePath)
                } catch {
                    print("create file failed")
                }
            }
            
            openFile(directory)
        } catch {
            print("read json file failed")
        }
        return createdFiles
    }
}

