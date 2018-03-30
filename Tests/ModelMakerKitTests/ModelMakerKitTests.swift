//
//  ModelMakerKitTests.swift
//  ModelMaker
//
//  Created by 张楠 on 2017/11/30.
//

import XCTest
@testable import ModelMakerKit

class ModelMakerKitTests: XCTestCase {
    let testData = [
                "favorited" : true,
                "attitudes_status" : 0,
                "created_at" : "Wed Sep 16 12:20:09 +0800 2015",
                "user" : [
                    "cover_image_phone" : "http://ww4.sinaimg.cn/crop.0.0.640.640.640/6ce2240djw1e8iktk4ohij20hs0hsmz6.jpg",
                    "id" : 3952070245,
                    "bi_followers_count" : 153,
                    "urank" : 23,
                    "icons" : [
                        [
                            "url" : "http://u1.sinaimg.cn/upload/2014/11/04/common_icon_membership_level5.png"
                        ]],
                    "badge" : [
                        "gongyi" : 0,
                        "gongyi_level" : 0,
                        "enterprise" : 0,
                        "zongyiji" : 1,
                        "suishoupai_2014" : 0,
                    ]
                ],
                "pic_ids" : [
                    "eb8fce65jw1ew466loxu0j20hs0dc755",
                    "eb8fce65jw1ew466lue7tj20l80fhjt2",
                    "eb8fce65jw1ew466mbh23j20qo0klmzv",
                    "eb8fce65jw1ew466pxg8yj21t037knpe",
                    "eb8fce65jw1ew466s6sucj21ix16ux6p"
                ],
                "darwin_tags" : [],
                "testIntArr" : [1, 2, 3, 4]
        ] as [String : Any]
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreateTree() {
        let tree = Tree.createTree(withDict: testData, rootNodeName: "test")
        print("\\\\\\\\\\")
        tree.rootNode.childs.forEach() {
            print($0.name + ":" + $0.type)
        }
        print("\\\\\\\\\\")
    }
    
    func testGetAllSubNodes() {
        let tree = Tree.createTree(withDict: testData, rootNodeName: "test")
        print("\\\\\\\\\\")
        tree.allSubNodes.forEach() {
            print($0.name + ":" + $0.type)
//            $0.childs.forEach() {
//                print($0.name + ":" + $0.type)
//            }
        }
        print("\\\\\\\\\\")
    }
    
    func testCreateSwiftFile() {
        print("\\\\\\\\\\")
        let modelMaker = ModelMaker()
        modelMaker.createModels(from: "/Users/zn/Desktop/test.json", to: "/Users/zn/Desktop/TestModelMaker", modelType: .swift).forEach { (file) in
            print(file)
        }
        print("\\\\\\\\\\")
    }
}
