//
//  ShareView.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/8/31.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  自定义分享view

import UIKit

class ShareView: UIView {
    weak var shareVC: UIViewController?
    var shareModel: ShareModel?
    
    fileprivate lazy var coverBtn: UIButton! = {
        let coverBtn = UIButton(frame: MainBounds)
        coverBtn.backgroundColor = UIColor.black
        coverBtn.alpha = 0.2
        coverBtn.addTarget(self, action: #selector(ShareView.coverClick), for: UIControlEvents.touchUpInside)
        return coverBtn
        }()
    
    class func shareViewFromXib() -> ShareView {
        let shareV = Bundle.main.loadNibNamed("ShareView", owner: nil, options: nil)?.last as! ShareView
        shareV.frame = CGRect(x: 0, y: AppHeight, width: AppWidth, height: theme.ShareViewHeight)
        return shareV
    }
 
    @IBAction func weChat(_ sender: AnyObject) {
        hideShareView()
        ShareTool.shareToWeChat(self.shareModel!)
    }
    
    @IBAction func friends(_ sender: AnyObject) {
        hideShareView()
        ShareTool.shareToWeChatFriends(self.shareModel!)
    }
    
    @IBAction func sina(_ sender: AnyObject) {
        hideShareView()
        ShareTool.shareToSina(self.shareModel!, viewController: shareVC)
    }
    
    @IBAction func cancle(_ sender: AnyObject) {
        hideShareView()
    }

    func showShareView(_ rect: CGRect) {
        self.superview?.insertSubview(coverBtn, belowSubview: self)
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.frame = rect
        })
    }
    
    func hideShareView() {
        coverBtn.removeFromSuperview()
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.frame = CGRect(x: 0, y: AppHeight, width: AppWidth, height: theme.ShareViewHeight)
        }, completion: { (finsch) -> Void in
            self.removeFromSuperview()
        }) 
    }
    
    func coverClick()  {
        hideShareView()
    }
}
