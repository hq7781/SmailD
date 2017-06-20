//
//  ExperienceCell.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/8/27.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  体验TableView的Cell

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class ExperienceCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageImageView: UIImageView!
    
    var eventModel: EventModel? {
        didSet {
            titleLabel.text = eventModel!.title
            
            if eventModel!.imgs?.count > 0 {
                let urlStr = eventModel!.imgs![0]
                imageImageView.wxn_setImageWithURL(URL(string: urlStr)! as NSURL, placeholderImage: UIImage(named: "quesheng")!)
            }
        }
    }
}
