//
//  RecommendViewController.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/9/12.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  应用推荐

import UIKit

class RecommendViewController: UIViewController {

    fileprivate lazy var webView: UIWebView! = {
        let webView = UIWebView(frame: MainBounds)
        let url = URL(string: "http://www.jianshu.com/users/5fe7513c7a57/latest_articles")!
        webView.loadRequest(URLRequest(url: url))
        webView.delegate = self
        return webView
        }()
    
    fileprivate let loadAnimatIV: LoadAnimatImageView! = LoadAnimatImageView.sharedManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "应用推荐"
        view.backgroundColor = theme.SDWebViewBacagroundColor
        view.addSubview(webView)
    }

}

extension RecommendViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        loadAnimatIV.startLoadAnimatImageViewInView(view, center: view.center)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loadAnimatIV.stopLoadAnimatImageView()
    }
    
}
