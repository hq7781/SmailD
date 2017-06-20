//
//  ExperHeadView.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/8/27.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  体验的顶部广告ScrollView

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class ExperHeadView: UIView, UIScrollViewDelegate {
    
    var experModel: ExperienceModel? {
        didSet {
            if experModel?.head?.count > 0 {
                page.numberOfPages = experModel!.head!.count
                scrollImageView.contentSize = CGSize(width: self.width * CGFloat(experModel!.head!.count), height: 0)
                
                for i in 0..<experModel!.head!.count {
                    let imageV = UIImageView(frame: CGRect(x: CGFloat(i) * AppWidth, y: 0, width: AppWidth, height: self.height * 0.8))
                    // Compile error! imageV.wxn_setImageWithURL(URL(string: experModel!.head![i].adurl!)!, placeholderImage: UIImage(named: "quesheng")!)
                    imageV.tag = i + 1000
                    
                    let tap = UITapGestureRecognizer(target: self, action: #selector(ExperHeadView.imageClick(_:)))
                    imageV.isUserInteractionEnabled = true
                    imageV.addGestureRecognizer(tap)
                    scrollImageView.addSubview(imageV)
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = theme.SDBackgroundColor
        
        addSubview(scrollImageView)
        
        addSubview(page)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollImageView.frame = CGRect(x: 0, y: 0, width: self.width, height: self.height * 0.8)
        page.frame = CGRect(x: 0, y: self.height * 0.8, width: self.width, height: self.height * 0.2)
    }
    
    ///MARK:- 懒加载对象
    fileprivate lazy var scrollImageView: UIScrollView = {
        let scrollImageView = UIScrollView()
        scrollImageView.delegate = self
        scrollImageView.showsHorizontalScrollIndicator = false
        scrollImageView.showsVerticalScrollIndicator = false
        scrollImageView.isPagingEnabled = true
        return scrollImageView
        }()
    
    fileprivate var page: UIPageControl = {
        let page = UIPageControl()
        page.pageIndicatorTintColor = UIColor.gray
        page.currentPageIndicatorTintColor = UIColor.black
        page.hidesForSinglePage = true
        return page
        }()
    
    weak var delegate: ExperHeadViewDelegate?
    
    func imageClick(_ tap: UITapGestureRecognizer) {
        delegate?.experHeadView(self, didClickImageViewAtIndex: tap.view!.tag - 1000)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

///MARK:- UIScrollViewDelegate
extension ExperHeadView {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let flag = Int(scrollView.contentOffset.x / scrollView.width)
        page.currentPage = flag
    }
}

///MARK:- 协议
protocol ExperHeadViewDelegate: NSObjectProtocol {
    
    func experHeadView(_ headView: ExperHeadView, didClickImageViewAtIndex index: Int)
    
}





