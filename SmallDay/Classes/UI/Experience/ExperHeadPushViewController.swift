//
//  ExperHeadPushViewController.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/8/27.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  体验点击头部scrollView推出的控制器

import UIKit

class ExperHeadPushViewController: UIViewController {
    
    var model:ExperienceHeadModel? {
        didSet {
            webView?.loadRequest(URLRequest(url: URL(string: model!.mobileURL!)!))
            navigationItem.title = model!.title
            shareView.shareModel = ShareModel(shareTitle: model!.title, shareURL: model!.shareURL, image: nil, shareDetail: model!.title)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = theme.SDBackgroundColor
        view.addSubview(webView!)
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "share_1", highlImageName: "share_2", targer: self, action: #selector(ExperHeadPushViewController.sharedClick))
    }
    
    /// MARK:- 懒加载对象
    fileprivate lazy var webView: UIWebView? = {
        let webView = UIWebView(frame: MainBounds)
        webView.delegate = self
        webView.backgroundColor = theme.SDBackgroundColor
        webView.isHidden = true
        return webView
        }()
    
    fileprivate lazy var shareView: ShareView = {
        let shareView = ShareView.shareViewFromXib()
        return shareView
        }()
    
    fileprivate lazy var loadImage = LoadAnimatImageView.sharedManager
    
    func sharedClick() {
        view.addSubview(shareView)
        shareView.shareVC = self
        shareView.showShareView(CGRect(x: 0, y: AppHeight - 215 - NavigationH, width: AppWidth, height: 215))
    }
}

extension ExperHeadPushViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        loadImage.startLoadAnimatImageViewInView(view, center: view.center)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.isHidden = false
        loadImage.stopLoadAnimatImageView()
        webView.scrollView.contentSize.height += NavigationH
    }
}
