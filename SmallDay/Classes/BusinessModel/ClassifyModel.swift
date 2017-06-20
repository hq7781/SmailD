//
//  ClassifyModel.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/8/25.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  分类模型

import UIKit

/// 分类首页模型
class ClassifyModel: NSObject, DictModelProtocol{
    var code: Int = -1
    var list: [ClassModel]?
    
    static func customClassMapping() -> [String : String]? {
        return ["list" : "\(ClassModel.self)"]
    }
    
    class func loadClassifyModel(_ completion: (_ data: ClassifyModel?, _ error: NSError?)->()) {
        let path = Bundle.main.path(forResource: "Classify", ofType: nil)
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
        if data != nil {
            let dict: NSDictionary = (try! JSONSerialization.jsonObject(with: data!, options: .allowFragments)) as! NSDictionary
            
            let modelTool = DictModelManager.sharedManager
            let data = modelTool.objectWithDictionary(dict, cls: ClassifyModel.self) as? ClassifyModel
            completion(data, nil)
        }
    }
}

class ClassModel: NSObject, DictModelProtocol{
    var title: String?
    var id: Int = -1
    var tags: [EveryClassModel]?
    
    static func customClassMapping() -> [String : String]? {
        return ["tags" : "\(EveryClassModel.self)"]
    }
}

class EveryClassModel: NSObject {
    /// 分类详情的个数
    var ev_count: Int = -1
    var id: Int = -1
    var img: String?
    var name: String?
}

class DetailModel: NSObject, DictModelProtocol {
    var msg: String?
    var code: Int = -1
    var list: [EventModel]?
    
    static func customClassMapping() -> [String : String]? {
        return ["list" : "\(EventModel.self)"]
    }
    
    /// 加载详情模型
    class func loadDetails(_ completion: (_ data: DetailModel?, _ error: NSError?) -> ()) {
        loadDatas("Details", isShowDis: false, completion: completion)
    }
    
    /// 加载美辑点击按钮的更多模型
    class func loadMore(_ completion: (_ data: DetailModel?, _ error: NSError?) -> ()) {
        loadDatas("More", isShowDis: false, completion: completion)
    }
    
    /// 加载附近店铺数据
    class func loadNearDatas(_ completion: (_ data: DetailModel?, _ error: NSError?) -> ()) {
        loadDatas("Nears", isShowDis: true, completion: completion)
    }
    
    fileprivate class func loadDatas(_ fileName: String, isShowDis: Bool, completion: (_ data: DetailModel?, _ error: NSError?) -> ()) {
        let path = Bundle.main.path(forResource: fileName, ofType: nil)
        if let data = try? Data(contentsOf: URL(fileURLWithPath: path!)) {
            let dict = (try! JSONSerialization.jsonObject(with: data, options: .allowFragments)) as! NSDictionary
            let modelTool = DictModelManager.sharedManager
            let datas = modelTool.objectWithDictionary(dict, cls: DetailModel.self) as? DetailModel
            if isShowDis {
                if datas!.list == nil {
                    NSLog("HONG Its Crashed !!!")
                    return
                }
                for event in datas!.list! {
                    event.isShowDis = true
                    if UserInfoManager.sharedUserInfoManager.userPosition != nil {
                        let userL = UserInfoManager.sharedUserInfoManager.userPosition!
                        let shopL = event.position!.stringToCLLocationCoordinate2D(",")!
                        let dis = MAMetersBetweenMapPoints(MAMapPointForCoordinate(userL), MAMapPointForCoordinate(shopL))
                        event.distanceForUser = String(format: "%.1fkm", dis * 0.001)
                    }
                }
            }
            completion(datas, nil)
        }
    }
}

class SearchsModel: NSObject, DictModelProtocol {
    var list: [EventModel]?
    static func customClassMapping() -> [String : String]? {
        return ["list" : "\(EventModel.self)"]
    }
    
    class func loadSearchsModel(_ title: String, completion: (_ data: SearchsModel?, _ error: NSError?) -> ()) {
        var path: String?
        if title == "南锣鼓巷" || title == "798" || title == "三里屯" {
            path = Bundle.main.path(forResource: title, ofType: nil)
        } else {
            path = Bundle.main.path(forResource: "南锣鼓巷", ofType: nil)
        }
        
        if let data = try? Data(contentsOf: URL(fileURLWithPath: path!)) {
            let dict = (try! JSONSerialization.jsonObject(with: data, options: .allowFragments)) as! NSDictionary
            let modelTool = DictModelManager.sharedManager
            let datas = modelTool.objectWithDictionary(dict, cls: SearchsModel.self) as? SearchsModel
            completion(datas, nil)
        }
        
    }
}









