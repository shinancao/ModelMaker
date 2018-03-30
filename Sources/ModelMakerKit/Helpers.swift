//
//  Helpers.swift
//  ModelMakerKit
//
//  Created by 张楠[产品技术中心] on 2018/3/29.
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


