//
//  ModelFileFormat.swift
//  ModelMakerKit
//
//  Created by 张楠 on 2018/3/29.
//

import Foundation

let modelFileFormatDict = [
    "SwiftTotalFile":"//\n//  [Swift-Model-Name].swift\n//  [Swift-Module-Name]\n//\n//  Created by [Swift-Author] on [Swift-Date].\n//  Copyright © [Swift-Year] [Swift-Organization]. All rights reserved.\n//\n\rimport Foundation\n\rstruct [Swift-Model-Name] {\n\r    // stored property\n\r[Swift-Stored-Property]\n\r}",
    "modelHeaderFileString":"//\n//  [ObjC-Model-Name].h\n//  Created by [Swift-Author] on [ObjC-Date].\n//  Copyright © [ObjC-Year] [Swift-Organization]. All rights reserved.\n//\n\r#import <Foundation/Foundation.h>\n\r@interface [ObjC-Model-Name] : NSObject\n\r[ObjC-Stored-Property]\n\r@end"
]


