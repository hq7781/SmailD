//
//  ShareModel.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/8/31.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  分享model

import UIKit

class ShareModel: NSObject {
   
    var shareTitle: String?
    var shareURL: String?
    var img: UIImage?
    var shareDetail: String?
    init(shareTitle: String?, shareURL: String?, image: UIImage?, shareDetail: String?) {
        super.init()
        if shareDetail != nil {
            if let text: NSString = NSString(cString: shareDetail!.cString(using: String.Encoding.utf8)!,encoding: String.Encoding.utf8.rawValue) {
                if text.length > 50 {
                    let aa = text.substring(to: 50)
                    self.shareDetail = aa as String
                } else {
                    self.shareDetail = shareDetail
                }
            }
        }
        self.shareTitle = shareTitle
        self.img = image
        self.shareURL = shareURL
    }
}
