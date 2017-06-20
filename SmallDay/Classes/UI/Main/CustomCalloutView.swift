//
//  CustomCalloutView.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/9/19.
//  Copyright © 2015年 维尼的小熊. All rights reserved.
//  自定义气泡

import UIKit

class CustomCalloutView: UIView {
    fileprivate var kArrorHeight: CGFloat = 10
    fileprivate let adressLabel = UILabel()
    fileprivate let navBtn = UIButton()
    
    var adressTitle: String? {
        didSet {
            adressLabel.text = adressTitle
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    fileprivate func setupUI() {
        backgroundColor = UIColor.clear
        adressLabel.textAlignment = .center
        adressLabel.font = UIFont.systemFont(ofSize: 20)
        adressLabel.text = "asdasdasdasdasadsasdakljkfjsfjsjlkfjsdfjslfdjlsf"
        addSubview(adressLabel)
        addSubview(navBtn)
        
        navBtn.setBackgroundImage(UIImage(named: "daohang"), for: UIControlState())
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        navBtn.frame = CGRect(x: self.width - 50 - 10, y: (self.height - 25) * 0.5, width: 50, height: 25)
        adressLabel.frame = CGRect(x: 10, y: 0, width: self.width - 80, height: self.height)
    }
    
    override func draw(_ rect: CGRect) {
        drawInContext(UIGraphicsGetCurrentContext()!)
    }
    
    fileprivate func drawInContext(_ context: CGContext) {
        context.setLineWidth(2.0)
        context.setFillColor(UIColor.white.cgColor)
        
        getDrawPath(context)
        context.fillPath()
    }
    
    fileprivate func getDrawPath(_ context: CGContext) {
        let rrect = self.bounds
        let radius: CGFloat = 6.0
        let minX = rrect.minX
        let midX = rrect.midX
        let maxX = rrect.maxX
        let minY = rrect.minY
        let maxY = rrect.maxY - kArrorHeight
        
        context.move(to: CGPoint(x: midX + kArrorHeight, y: maxY))
        context.move(to: CGPoint(x: midX, y: maxY + kArrorHeight))
        context.move(to: CGPoint(x: midX - kArrorHeight, y: maxY))
        
//        CGContextAddArcToPoint(context, minX, maxY, minX, minY, radius)
//        CGContextAddArcToPoint(context, minX, minX, maxX, minY, radius)
//        CGContextAddArcToPoint(context, maxX, minY, maxX, maxX, radius)
//        CGContextAddArcToPoint(context, maxX, maxY, midX, maxY, radius)
        context.addArc(center: CGPoint(x: minX, y: maxY), radius: radius,startAngle: minX, endAngle:minY, clockwise: true )
        context.addArc(center: CGPoint(x: minX, y: minX), radius: radius,startAngle: maxX, endAngle:minY, clockwise: true )
        context.addArc(center: CGPoint(x: maxX, y: minX), radius: radius,startAngle: maxX, endAngle:maxX, clockwise: true )
        context.addArc(center: CGPoint(x: maxX, y: maxY), radius: radius,startAngle: midX, endAngle:maxX, clockwise: true )
        context.closePath()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
