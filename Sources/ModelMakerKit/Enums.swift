//
//  Enums.swift
//  ModelMakerKit
//
//  Created by 张楠 on 2018/3/29.
//

import Foundation

public enum ModelMakerError: Error {
    case readFileFailed
    case jsonFormatWrong
    case writeFileFailed
}

public enum ModelType: String {
    case objc  = "o"
    case swift = "s"
    
    public var description: String {
        switch self {
        case .objc:
            return "Objective-C"
        case .swift:
            return "Swift"
        }
    }
}

public enum SwiftBasePropertyType: String {
    case kString = "String"
    case kInt = "Int"
    case kFloat = "Float"
    case kBool = "Bool"
    case kStringArray = "[String]"
    case kIntArray = "[Int]"
    case kFloatArray = "[Float]"
    case kBoolArray = "[Bool]"
}

public extension SwiftBasePropertyType {
    public static func customArrayPropertyType(with string: String) -> String {
        return "[\(modelNameHelper.generateName(with: string))]"
    }
    
    public static func getClassType(with propertyType: String) -> String {
        return propertyType.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
    }
}

public enum ObjCBasePropertyType: String {
    case kNSString = "NSString *"
    case kNSNumber = "NSNumber *"
    case kNSStringArray = "NSArray<NSString *> *"
    case kNSNumberArray = "NSArray<NSNumber *> *"
}

public extension ObjCBasePropertyType {
    public static func customPropertyType(with string: String) -> String {
        return modelNameHelper.generateName(with: string) + " *"
    }
    
    public static func customArrayPropertyType(with string: String) -> String {
        return "NSArray<\(modelNameHelper.generateName(with: string)) *> *"
    }
    
    public static func getClassType(with propertyType: String) -> String {
        return propertyType.replacingOccurrences(of: "NSArray<", with: "").replacingOccurrences(of: " *>", with: "").replacingOccurrences(of: " *", with: "")
    }
}

public enum ObjCJSONModelPropertyType: String {
    case kNSString = "NSString<Optional> *"
    case kNSNumber = "NSNumber<Optional> *"
    case kNSStringArray = "NSArray<NSString *><Optional> *"
    case kNSNumberArray = "NSArray<NSNumber *><Optional> *"
}

public extension ObjCJSONModelPropertyType {
    public static func customPropertyType(with string: String) -> String {
        return modelNameHelper.generateName(with: string) + "<Optional> *"
    }
    
    public static func customArrayPropertyType(with string: String) -> String {
        return "NSArray<\(modelNameHelper.generateName(with: string)) *><\(modelNameHelper.generateName(with: string)), Optional> *"
    }
    
    public static func getClassType(with propertyType: String) -> String {
        if let endIndex = propertyType.range(of: " *>")?.lowerBound {
            let startIndex = propertyType.index("NSArray<".endIndex, offsetBy: 0)
            return propertyType[startIndex..<endIndex]
        } else {
            return propertyType.replacingOccurrences(of: "<Optional> *", with: "")
        }
    }
    
    
}
