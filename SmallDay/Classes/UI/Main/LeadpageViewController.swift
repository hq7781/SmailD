//
//  LeadpageViewController.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/9/10.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//   引导页

import UIKit

public let SD_ShowMianTabbarController_Notification = "SD_Show_MianTabbarController_Notification"

class LeadpageViewController: UIViewController {
    
    fileprivate let backgroundImage = UIImageView(frame: MainBounds)
    fileprivate let startBtn: NoHighlightButton = NoHighlightButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var imageName: String?
        switch AppWidth {
        case 375: imageName = Bundle.main.path(forResource: "fourpage-375w-667h@2x.jpg", ofType: nil)
        case 414: imageName = Bundle.main.path(forResource: "fourpage-414w-736h@3x.jpg", ofType: nil)
        case 568: imageName = Bundle.main.path(forResource: "fourpage-568h@2x.jpg", ofType: nil)
        default: imageName = Bundle.main.path(forResource: "fourpage@2x.jpg", ofType: nil)
            
        }
        
        backgroundImage.image = UIImage(contentsOfFile: imageName!)
        view.addSubview(backgroundImage)
        
        startBtn.setBackgroundImage(UIImage(named: "into_home"), for: UIControlState())
        startBtn.setTitle("开始小日子", for: UIControlState())
        startBtn.setTitleColor(UIColor.white, for: UIControlState())
        startBtn.frame = CGRect(x: (AppWidth - 210) * 0.5, y: AppHeight - 120, width: 210, height: 45)
        startBtn.addTarget(self, action: #selector(LeadpageViewController.showMainTabbar), for: .touchUpInside)
        view.addSubview(startBtn)
    }
    
    func showMainTabbar() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: SD_ShowMianTabbarController_Notification), object: nil)
    }
    
}
