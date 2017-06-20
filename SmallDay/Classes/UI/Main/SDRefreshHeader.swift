//
//  SDRefreshHeader.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/9/12.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  DIY 自己的下拉刷新动画

import UIKit

class SDRefreshHeader: MJRefreshGifHeader {
    
    override func prepare() {
        super.prepare()
        stateLabel!.isHidden = true
        lastUpdatedTimeLabel!.isHidden = true
        
        let idleImages = NSMutableArray()
        let idImage = UIImage(named: "wnx00")
        idleImages.add(idImage!)
        setImages(idleImages as [AnyObject], for: MJRefreshStateIdle)
        
        let refreshingImages = NSMutableArray()
        let refreshingImage = UIImage(named: "wnx00")!
        refreshingImages.add(refreshingImage)
        setImages(refreshingImages as [AnyObject], for: MJRefreshStatePulling)

        let refreshingStartImages = NSMutableArray()
        for i in 0...92 {
            let image = UIImage(named: String(format: "wnx%02d", i))
            refreshingStartImages.add(image!)
        }
        setImages(refreshingStartImages as [AnyObject], for: MJRefreshStateRefreshing)
     
    }
    
}
