//
//  SearchButton.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/9/17.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  搜索控制器搜索按钮

import UIKit

class SearchButton: UIButton {
    
    init(frame: CGRect, target: AnyObject, action: Selector) {
        super.init(frame: frame)
        
        setTitle("搜索", for: UIControlState())
        setTitle("取消", for: .selected)
        titleLabel!.font = UIFont.systemFont(ofSize: 18)
        setTitleColor(UIColor.black, for: UIControlState())
        setTitleColor(UIColor.black, for: .selected)
        alpha = 0
        titleLabel!.textAlignment = .center
        addTarget(target, action: action, for: .touchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
