//
//  ProjectInformation.swift
//  ModelMakerKit
//
//  Created by 张楠 on 2018/1/21.
//

import Foundation

struct ProjectInformation {
    let author: String
    let dateString: String
    let yearString: String
    
    init() {
        self.author = NSUserName()
        
        let date = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        self.dateString = formatter.string(from: date)
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        self.yearString = "\(year)年"
    }
}

let projectInfo = ProjectInformation()
