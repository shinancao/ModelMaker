//
//  CommandPrompt.swift
//  ModelMaker
//
//  Created by Shinancao on 2018/4/22.
//

import Foundation
import Rainbow

public func inheritFromJSONModel() -> Bool {
    print("Do these Objective-C models inherit from JSONModel? (y)es|(n)o".bold, terminator:" ")
    
    guard let result = readLine() else {
        return inheritFromJSONModel()
    }
    
    switch result {
    case "y", "Y": return true
    case "n", "N": return false
    default: return inheritFromJSONModel()
    }
}
