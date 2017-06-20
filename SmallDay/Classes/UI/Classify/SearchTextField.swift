//
//  SearchTextField.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/8/18.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  自定义的搜索框

import UIKit

class SearchTextField: UITextField {

    fileprivate var leftV: UIView!
    fileprivate var leftImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        leftImageView = UIImageView(image: UIImage(named: "search"))
        leftV = UIView(frame: CGRect(x: 5, y: 0, width: 10 * 2 + leftImageView.width, height: 30))
        leftImageView.frame.origin = CGPoint(x: 5, y: (leftV.height - leftImageView.height) * 0.5)
        leftV.addSubview(leftImageView)
        self.autocorrectionType = .no
        leftView = leftV
        leftViewMode = UITextFieldViewMode.always
        background = UIImage(named: "searchbox")
        placeholder = "爱好 主题 标签 店名"
        
        clearButtonMode = UITextFieldViewMode.always
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        leftView?.frame.origin.x = 10

    }
}
