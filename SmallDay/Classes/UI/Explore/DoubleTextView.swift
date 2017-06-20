//
//  DoubleTextView.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/8/16.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  探店的titleView

import UIKit

class DoubleTextView: UIView {
    
    fileprivate let leftTextButton: NoHighlightButton =  NoHighlightButton()
    fileprivate let rightTextButton: NoHighlightButton = NoHighlightButton()
    fileprivate let textColorFroNormal: UIColor = UIColor(red: 100 / 255.0, green: 100 / 255.0, blue: 100 / 255.0, alpha: 1)
    fileprivate let textFont: UIFont = theme.SDNavTitleFont
    fileprivate let bottomLineView: UIView = UIView()
    fileprivate var selectedBtn: UIButton?
    weak var delegate: DoubleTextViewDelegate?

    /// 便利构造方法
    convenience init(leftText: String, rigthText: String) {
        self.init()
        // 设置左边文字
        setButton(leftTextButton, title: leftText, tag: 100)
        // 设置右边文字
        setButton(rightTextButton, title: rigthText, tag: 101)
        // 设置底部线条View
        setBottomLineView()
        
        titleButtonClick(leftTextButton)
    }
    
    fileprivate func setBottomLineView() {
        bottomLineView.backgroundColor = UIColor(red: 60 / 255.0, green: 60 / 255.0, blue: 60 / 255.0, alpha: 1)
        addSubview(bottomLineView)
    }
    
    fileprivate func setButton(_ button: UIButton, title: String, tag: Int) {
        button.setTitleColor(UIColor.black, for: .selected)
        button.setTitleColor(textColorFroNormal, for: UIControlState())        
        button.titleLabel?.font = textFont
        button.tag = tag
        button.addTarget(self, action: #selector(DoubleTextView.titleButtonClick(_:)), for: .touchUpInside)
        button.setTitle(title, for: UIControlState())
        addSubview(button)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let btnW = width * 0.5
        leftTextButton.frame = CGRect(x: 0, y: 0, width: btnW, height: height)
        rightTextButton.frame = CGRect(x: btnW, y: 0, width: btnW, height: height)
        bottomLineView.frame = CGRect(x: 0, y: height - 2, width: btnW, height: 2)
    }
    
    func titleButtonClick(_ sender: UIButton) {
        selectedBtn?.isSelected = false
        sender.isSelected = true
        selectedBtn = sender
        bottomViewScrollTo(sender.tag - 100)
        delegate?.doubleTextView(self, didClickBtn: sender, forIndex: sender.tag - 100)
    }
    
    func bottomViewScrollTo(_ index: Int) {
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.bottomLineView.frame.origin.x = CGFloat(index) * self.bottomLineView.width
        })
    }
    
    func clickBtnToIndex(_ index: Int) {
        let btn: NoHighlightButton = self.viewWithTag(index + 100) as! NoHighlightButton
        self.titleButtonClick(btn)
    }
}

/// DoubleTextViewDelegate协议
protocol DoubleTextViewDelegate: NSObjectProtocol{

    func doubleTextView(_ doubleTextView: DoubleTextView, didClickBtn btn: UIButton, forIndex index: Int)
    
}

/// 没有高亮状态的按钮
class NoHighlightButton: UIButton {
    /// 重写setFrame方法
    override var isHighlighted: Bool {
        didSet{
            super.isHighlighted = false
        }
    }
}
