//
//  MainViewController.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/8/16.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  基类控制器, 带有选择城市的ViewController

import UIKit

class MainViewController: UIViewController {
    
    var cityRightBtn: TextImageButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.cityChange(_:)), name: NSNotification.Name(rawValue: SD_CurrentCityChange_Notification), object: nil)
        
        cityRightBtn = TextImageButton(frame: CGRect(x: 0, y: 20, width: 80, height: 44))
        let user = UserDefaults.standard
        if let currentCity = user.object(forKey: SD_Current_SelectedCity) as? String {
            cityRightBtn.setTitle(currentCity, for: UIControlState())
        } else {
            cityRightBtn.setTitle("北京", for: UIControlState())
        }
        
        cityRightBtn.titleLabel?.font = theme.SDNavItemFont
        cityRightBtn.setTitleColor(UIColor.black, for: UIControlState())
        cityRightBtn.setImage(UIImage(named: "home_down"), for: UIControlState())
        cityRightBtn.addTarget(self, action: #selector(MainViewController.pushcityView), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cityRightBtn)
        
    }
    
    func pushcityView () {
        let cityVC = CityViewController()
        cityVC.cityName = self.cityRightBtn.title(for: UIControlState())
        let nav = MainNavigationController(rootViewController: cityVC)
        present(nav, animated: true, completion: nil)
    }
    
    func cityChange(_ noti: Notification) {
        if let currentCityName = noti.object as? String {
            self.cityRightBtn.setTitle(currentCityName, for: UIControlState())
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: 自定义button,文字在左边 图片在右边
class TextImageButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel?.font = theme.SDNavItemFont
        titleLabel?.contentMode = UIViewContentMode.center
        imageView?.contentMode = UIViewContentMode.left

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.sizeToFit()
        titleLabel?.frame = CGRect(x: -5, y: 0, width: titleLabel!.width, height: height)
        imageView?.frame = CGRect(x: titleLabel!.width + 3 - 5, y: 0, width: width - titleLabel!.width - 3, height: height)
    }
}
