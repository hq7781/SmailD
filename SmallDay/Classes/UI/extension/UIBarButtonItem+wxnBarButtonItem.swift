//
//  UIBarButtonItem+wxnBarButtonItem.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/9/8.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//

import Foundation

/// 扩展UIBarButtonItem
extension UIBarButtonItem {
    /// 针对导航条右边按钮的自定义item
    convenience init(imageName: String, highlImageName: String, targer: AnyObject, action: Selector) {
        let button: UIButton = UIButton(type: .custom)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.setImage(UIImage(named: highlImageName), for: .highlighted)
        //button.frame = CGRectMake(x: 0, y: 0, width: 50, height: 44)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 44)
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        button.addTarget(targer, action: action, for: .touchUpInside)
        
        self.init(customView: button)
    }
    
    /// 针对导航条右边按钮有选中状态的自定义item
    convenience init(imageName: String, highlImageName: String, selectedImage: String, targer: AnyObject, action: Selector) {
        let button: UIButton = UIButton(type: .custom)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.setImage(UIImage(named: highlImageName), for: .highlighted)
        //button.frame = CGRectMake(x: 0, y: 0, width: 50, height: 44)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 44)
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10)
        button.setImage(UIImage(named: selectedImage), for: .selected)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        button.addTarget(targer, action: action, for: .touchUpInside)
        
        self.init(customView: button)
    }
    
    /// 针对导航条左边按钮的自定义item
    convenience init(leftimageName: String, highlImageName: String, targer: AnyObject, action: Selector) {
        let button: UIButton = UIButton(type: .custom)
        button.setImage(UIImage(named: leftimageName), for: .normal)
        button.setImage(UIImage(named: highlImageName), for: .highlighted)
        //button.frame = CGRectMake(x: 0, y: 0, width: 80, height: 44)
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 44)
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        button.addTarget(targer, action: action, for: .touchUpInside)
        
        self.init(customView: button)
    }
    
    
    
    /// 导航条纯文字按钮
    convenience init(title: String, titleClocr: UIColor, targer: AnyObject ,action: Selector) {
        
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleClocr, for: .normal)
        button.titleLabel?.font = theme.SDNavItemFont
        button.setTitleColor(UIColor.gray, for: .highlighted)
        //button.frame = CGRectMake(x: 0, y: 0, width: 80, height: 44)
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 44)
        button.titleLabel?.textAlignment = NSTextAlignment.right
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5)
        button.addTarget(targer, action: action, for: .touchUpInside)
        
        self.init(customView: button)
    }

    func CGRectMake( x: CGFloat,  y: CGFloat, width:CGFloat, height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
}
