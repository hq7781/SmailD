//
//  ShopDetailContentView.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/9/8.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  店.详情的contentView


import UIKit

class ShopDetailContentView: UIView {
    
    @IBOutlet weak fileprivate var shopName: UILabel!
    @IBOutlet weak fileprivate var phoneNumberLabel: UILabel!
    @IBOutlet weak fileprivate var adressLabel: UILabel!
    @IBOutlet weak fileprivate var correctBtn: UIButton!
    
    var mapBtnClickCallback:(() -> ())?
    
    var shopDetailContentViewHeight: CGFloat = 0
    var detailModel: EventModel? {
        didSet {
            shopName.text = detailModel!.remark
            phoneNumberLabel.text = detailModel!.telephone
            adressLabel.text = detailModel!.address
            // 计算出contentView的高度
            shopDetailContentViewHeight = correctBtn.frame.maxY
        }
    }
    
    class func shopDetailContentViewFromXib() -> ShopDetailContentView {
        let shopView = Bundle.main.loadNibNamed("ShopDetailContentView", owner: nil, options: nil)?.last as! ShopDetailContentView
        shopView.frame.size.width = AppWidth
        shopView.backgroundColor = theme.SDWebViewBacagroundColor
        return shopView
    }
    
    @IBAction func callBtnCleck(_ sender: UIButton) {
        if detailModel?.telephone == "" {
            return
        }
        callActionSheet.show(in: self)
    }
    
    @IBAction func mapBtnClick(_ sender: UIButton) {
//        let naviVC = NavigatorViewController()
        mapBtnClickCallback!()
    }
    
    @IBAction func correctBtnClick(_ sender: UIButton) {
        correctActionSheet.show(in: self)
    }
    
    /// MARK:- 懒加载属性
    fileprivate lazy var callActionSheet: UIActionSheet = {
        let call = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: self.phoneNumberLabel.text)
        return call
        }()
    fileprivate lazy var correctActionSheet: UIActionSheet = {
        let correct = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "地址错误", "电话错误", "店名/店铺介绍/图片错误", "关门/歇业/即将转让")
        return correct
        }()
}

extension ShopDetailContentView: UIActionSheetDelegate {
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if actionSheet === callActionSheet {
            if buttonIndex == 0 {
                let numURL = "tel://" + phoneNumberLabel.text!
                UIApplication.shared.openURL(URL(string: numURL)!)
            }
        } else if actionSheet === correctActionSheet {
            switch buttonIndex {
            case 1, 2, 3, 4: SVProgressHUD.showSuccess(withStatus: "反馈成功", maskType: SVProgressHUDMaskType.black)
            default: break
            }
        }
    }
    
}
