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
    case createFileFailed
}

public enum ModelType: String {
    case objc  = "o"
    case swift = "s"
    case both  = "b"
    
    public func description() -> String {
        switch self {
        case .objc:
            return "Objective-C"
        case .swift:
            return "Swift"
        case .both:
            return "Both Objective-C and Swift"
        }
    }
}
