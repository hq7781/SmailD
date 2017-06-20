//
//  MainNavigationViewController.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/8/14.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  基类导航控制器

import UIKit

class MainNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.interactivePopGestureRecognizer!.delegate = nil;
    }
    
    lazy var backBtn: UIButton = {
        //设置返回按钮属性
        let backBtn = UIButton(type: UIButtonType.custom)
        backBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        backBtn.setTitleColor(UIColor.black, for: UIControlState())
        backBtn.setTitleColor(UIColor.gray, for: .highlighted)
        backBtn.setImage(UIImage(named: "back_1"), for: UIControlState())
        backBtn.setImage(UIImage(named: "back_2"), for: .highlighted)
        backBtn.addTarget(self, action: #selector(MainNavigationController.backBtnClick), for: .touchUpInside)
        backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0)
        backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0)
        let btnW: CGFloat = AppWidth > 375.0 ? 50 : 44
        backBtn.frame = CGRect(x: 0, y: 0, width: btnW, height: 40)
        return backBtn
        }()
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if self.childViewControllers.count > 0 {
            let vc = self.childViewControllers[0]
            
            if self.childViewControllers.count == 1 {
                backBtn.setTitle(vc.tabBarItem.title!, for: UIControlState())
            } else {
                backBtn.setTitle("返回", for: UIControlState())
            }
            
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
            
            viewController.hidesBottomBarWhenPushed = true
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    func backBtnClick() {
        self.popViewController(animated: true)
    }
    
}
