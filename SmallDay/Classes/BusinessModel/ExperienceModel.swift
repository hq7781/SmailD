//  ExperienceModel.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/8/27.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  体验模型

import UIKit

class ExperienceModel: NSObject, DictModelProtocol {
    var head: [ExperienceHeadModel]?
    var list: [EventModel]?
    
    static func customClassMapping() -> [String : String]? {
        return ["head" : "\(ExperienceHeadModel.self)", "list" : "\(EventModel.self)"]
    }
    
    class func loadExperienceModel(_ completion: (_ data: ExperienceModel?, _ error: NSError?) -> ()) {
        let path = Bundle.main.path(forResource: "Experience", ofType: nil)
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
        if data != nil {
            let dict: NSDictionary = (try! JSONSerialization.jsonObject(with: data!, options: .allowFragments)) as! NSDictionary
            
            let modelTool = DictModelManager.sharedManager
            let data = modelTool.objectWithDictionary(dict, cls: ExperienceModel.self) as? ExperienceModel
            completion(data, nil)
        }
        
    }
}

class ExperienceHeadModel: NSObject {
    var feel: String?
    var shareURL: String?
    var tag: String?
    var id: Int = -1
    /// imageURL
    var adurl: String?
    var title: String?
    var mobileURL: String?
}
