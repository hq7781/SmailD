//
//  IconView.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/8/19.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  用户头像的View

import UIKit

class IconView: UIView {
    
    var iconButton: UIButton!
    weak var delegate: IconViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    fileprivate func setUp() {
        self.backgroundColor = UIColor.clear
        iconButton = UIButton(type: .custom) 
        iconButton.setImage(UIImage(named: "my"), for: UIControlState())
        iconButton.addTarget(self, action: #selector(IconView.iconBtnClick), for: .touchUpInside)
        iconButton.clipsToBounds = true
        addSubview(iconButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let mrgin: CGFloat = 8
        iconButton.frame = CGRect(x: mrgin, y: mrgin, width: self.width - mrgin * 2, height: self.height - mrgin * 2)
        iconButton.setBackgroundImage(UIImage(named: "white")?.imageClipOvalImage(), for: .normal)
    }
    
    override func draw(_ rect: CGRect) {
        let circleWidth: CGFloat = 2
        // 圆角矩形
        let path = UIBezierPath(roundedRect: CGRect(x: circleWidth, y: circleWidth, width: rect.size.width - circleWidth * 2, height: rect.size.width - circleWidth * 2), cornerRadius: rect.size.width)
        path.lineWidth = circleWidth
        UIColor.white.set()
        path.stroke()
    }
    
    func iconBtnClick() {
        delegate?.iconView(self, didClick: self.iconButton)
    }
}


protocol IconViewDelegate: NSObjectProtocol {
    func iconView(_ iconView: IconView, didClick iconButton: UIButton)
}
