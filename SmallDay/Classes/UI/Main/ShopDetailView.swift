//
//  ShopDetailView.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/8/28.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  店发现,详情view

import UIKit

class ShopDetailView: UIView {
    
    fileprivate var findLabel: UILabel!
    fileprivate var detailLabel: UILabel!
    fileprivate var middleLineView: UIView!
    fileprivate var bottomLineView: UIView!
    weak var delegate: ShopDetailViewDelegate?
    fileprivate let bottomLineScale: CGFloat = 0.6
    fileprivate var blackLineView: UIView!
    fileprivate var bottomBlackLineView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        blackLineView = UIView()
        blackLineView.alpha = 0.05
        blackLineView.backgroundColor = UIColor.darkGray
        addSubview(blackLineView)
        
        bottomBlackLineView = UIView()
        bottomBlackLineView.alpha = 0.03
        bottomBlackLineView.backgroundColor = UIColor.gray
        addSubview(bottomBlackLineView)
        
        findLabel = UILabel()
        setLabel(findLabel, text: "店 · 发现", action: #selector(ShopDetailView.labelClick(_:)), tag: 0)
        
        detailLabel = UILabel()
        setLabel(detailLabel, text: "店 · 详情", action: #selector(ShopDetailView.labelClick(_:)), tag: 1)
        
        middleLineView = UIView()
        middleLineView.backgroundColor = UIColor.colorWith(50, green: 50, blue: 50, alpha: 0.1)
        addSubview(middleLineView)
        
        bottomLineView = UIView()
        bottomLineView.backgroundColor = UIColor.colorWith(50, green: 50, blue: 50, alpha: 1)
        addSubview(bottomLineView)
    }
    
    fileprivate func setLabel(_ label: UILabel, text: String, action: Selector, tag: Int) {
        label.text = text
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.black
        label.isUserInteractionEnabled = true
        label.tag = tag
        let tap = UITapGestureRecognizer(target: self, action: action)
        label.addGestureRecognizer(tap)
        self.addSubview(label)
    }
    
    
    func labelClick(_ tap: UITapGestureRecognizer) {
        let index = tap.view!.tag
        
        if delegate != nil {
            if delegate!.responds(to: #selector(ShopDetailViewDelegate.shopDetailView(_:didSelectedLable:))) {
                delegate!.shopDetailView!(self, didSelectedLable: index)
            }
        }
        let labelW = self.width * 0.5
        let bottomLineW = labelW * bottomLineScale
        let bottomLineH: CGFloat = 1.5
        let bottomLineX: CGFloat = CGFloat(index) * labelW + (labelW - bottomLineW) * 0.5
        let bottomLineY: CGFloat = self.height - bottomLineH
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.bottomLineView.frame = CGRect(x: bottomLineX, y: bottomLineY, width: bottomLineW, height: bottomLineH)
        })
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let labelW = self.width * 0.5
        let labelH = self.height
        findLabel.frame = CGRect(x: 0, y: 0, width: labelW, height: labelH)
        detailLabel.frame = CGRect(x: labelW, y: 0, width: labelW, height: labelH)
        
        let lineH = labelH * 0.5
        middleLineView.frame = CGRect(x: labelW - 0.5, y: (labelH - lineH) * 0.5, width: 1,  height: lineH)
        let bottomLineW = labelW * bottomLineScale
        bottomLineView.frame = CGRect(x: (labelW - bottomLineW) * 0.5, y: labelH - 1.5, width: bottomLineW, height: 1.5)
        
        blackLineView.frame = CGRect(x: 0, y: 0, width: self.width, height: 1)
        bottomBlackLineView.frame = CGRect(x: 0, y: self.height, width: self.width, height: 1)
    }
    
}

@objc protocol ShopDetailViewDelegate: NSObjectProtocol {
    
    @objc optional func shopDetailView(_ shopDetailView: ShopDetailView, didSelectedLable index: Int)
}





