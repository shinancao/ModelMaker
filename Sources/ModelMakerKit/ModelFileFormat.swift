//
//  ModelFileFormat.swift
//  ModelMakerKit
//
//  Created by 张楠 on 2018/3/29.
//

import Foundation

let modelFileFormatDict = [
    "SwiftTotalFile":"//\n//  [Swift-Model-Name].swift\n//  [Swift-Module-Name]\n//\n//  Created by [Swift-Author] on [Swift-Date].\n//  Copyright © [Swift-Year] [Swift-Organization]. All rights reserved.\n//\n\rimport Foundation\n\rstruct [Swift-Model-Name] {\n\r[Swift-Stored-Property]\n\r}",
    "modelHeaderFileString":"//\n//  [ObjC-Model-Name].h\n//  [ObjC-Project-Name]\n//\n//  Created by [ObjC-Author] on [ObjC-Date].\n//  Copyright © [ObjC-Year] [ObjC-Organization]. All rights reserved.\n//\n\r#import <Foundation/Foundation.h>\n\r[ObjC-Declare-Class]@interface [ObjC-Model-Name] : NSObject\n\r[ObjC-Stored-Property]\n\r@end",
    "modelMFileString":"//\n//  [ObjC-Model-Name].m\n//  Created by [ObjC-Author] on [ObjC-Date].\n//  Copyright © [ObjC-Year] [ObjC-Organization]. All rights reserved.\n//\n\r#import \"[ObjC-Model-Name].h\"\n\r[Objc-Import-Class]@implementation [ObjC-Model-Name]\n\r@end"
]


