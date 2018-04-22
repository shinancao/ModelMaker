//
//  Helpers.swift
//  ModelMakerKit
//
//  Created by 张楠 on 2018/3/29.
//

import Foundation

public class ModelNameHelper {
    public var prefix: String
    public var suffix: String
    
    public init() {
        self.prefix = ""
        self.suffix = "Model"
    }
    
    public func generateName(with value: String) -> String {
        return self.prefix + value.capitalized + self.suffix
    }
}

public let modelNameHelper = ModelNameHelper()

public class ModelPropertyHelper {
    public var inheritFromJSONModel: Bool
    
    public init() {
        self.inheritFromJSONModel = false
    }
    
    var unknowType: String { return "\"unknown type\"" }
    
    var objcString: String {
        if inheritFromJSONModel {
            return ObjCJSONModelPropertyType.kNSString.rawValue
        } else {
            return ObjCBasePropertyType.kNSString.rawValue
        }
    }
    
    var objcNumber: String {
        if inheritFromJSONModel {
            return ObjCJSONModelPropertyType.kNSNumber.rawValue
        } else {
            return ObjCBasePropertyType.kNSNumber.rawValue
        }
    }
    
    var objcStringArray: String {
        if inheritFromJSONModel {
            return ObjCJSONModelPropertyType.kNSStringArray.rawValue
        } else {
            return ObjCBasePropertyType.kNSStringArray.rawValue
        }
    }
    
    var objcNumberArray: String {
        if inheritFromJSONModel {
            return ObjCJSONModelPropertyType.kNSNumberArray.rawValue
        } else {
            return ObjCBasePropertyType.kNSNumberArray.rawValue
        }
    }
    
    func objcCustomType(with string: String) -> String {
        if inheritFromJSONModel {
            return ObjCJSONModelPropertyType.customPropertyType(with: string)
        } else {
            return ObjCBasePropertyType.customPropertyType(with: string)
        }
    }
    
    func objcCustomArrayType(with string: String) -> String {
        if inheritFromJSONModel {
            return ObjCJSONModelPropertyType.customArrayPropertyType(with: string)
        } else {
            return ObjCBasePropertyType.customArrayPropertyType(with: string)
        }
    }
    
    func getObjcClassType(with propertyType: String) -> String {
        if inheritFromJSONModel {
            return ObjCJSONModelPropertyType.getClassType(with: propertyType)
        } else {
            return ObjCBasePropertyType.getClassType(with: propertyType)
        }
    }
    
    func isObjcBaseType(propertyType: String) -> Bool {
        if inheritFromJSONModel {
            return ObjCJSONModelPropertyType(rawValue: propertyType) != nil || propertyType == unknowType
        } else {
            return ObjCBasePropertyType(rawValue: propertyType) != nil || propertyType == unknowType
        }
    }
    
    func isCustomArray(propertyType: String) -> Bool {
        if !isObjcBaseType(propertyType: propertyType) {
            return propertyType.contains("NSArray")
        } else {
            return false
        }
    }
}

public let modelPropertyHelper = ModelPropertyHelper()


