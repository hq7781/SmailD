//
//  MyCenterViewController.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/9/9.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  个人中心控制器

import UIKit

class MyCenterViewController: UIViewController {

    @IBOutlet weak fileprivate var alterPwdView: UIView!
    @IBOutlet weak fileprivate var iconView: IconView!
    @IBOutlet weak var accountLabel: UILabel!
    
    init() {
        super.init(nibName: "MyCenterViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: "MyCenterViewController", bundle: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(MyCenterViewController.alterPwdViewClick))
        alterPwdView.isUserInteractionEnabled = true
        alterPwdView.addGestureRecognizer(tap)
        accountLabel.text = UserAccountTool.userAccount()!
        
        if let data = try? Data(contentsOf: URL(fileURLWithPath: SD_UserIconData_Path)) {
            let image: UIImage = UIImage(data: data)!
            iconView.iconButton.setImage(image.imageClipOvalImage(), for: .normal)
        }
    }
    
    func alterPwdViewClick() {
        print("修改密码", terminator: "")
    }
    
    @IBAction func logoutBtnClick(_ sender: UIButton) {
        let user = UserDefaults.standard
        user.set(nil, forKey: SD_UserDefaults_Account)
        user.set(nil, forKey: SD_UserDefaults_Password)
        if user.synchronize() {
            navigationController!.popViewController(animated: true)
        }
        do {
            // 将本地的icon图片data删除
            try FileManager.default.removeItem(atPath: SD_UserIconData_Path)
        } catch _ {
        }
    }

    deinit {
        print("个人中心控制器被销毁", terminator: "")
    }
}
