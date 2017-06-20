//
//  ThemeViewController.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/8/22.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  ThemeCell点击出来的ViewController

import UIKit

/// DetailCell的公共标识
public let SD_DetailCell_Identifier = "DetailCell"

class ThemeViewController: UIViewController, UIWebViewDelegate {
    var themeModel: ThemeModel? {
        didSet {
            if themeModel?.hasweb == 1 {
                self.webView?.loadRequest(URLRequest(url: URL(string: themeModel!.themeurl!)!))
                shareView?.shareModel = ShareModel(shareTitle: themeModel?.title, shareURL: themeModel?.themeurl, image: nil, shareDetail: themeModel?.text)
            }
        }
    }
    var more: DetailModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初始化UI
        setUpUI()
        // 加载更多数据
        loadMore()
        // 添加modalBtn
        addModalBtn()
    }
    
    //MARK:- 懒加载属性
    fileprivate lazy var backView: UIView = {
        let backView = UIView(frame: MainBounds)
        backView.backgroundColor = theme.SDBackgroundColor
        return backView
        }()
    
    fileprivate lazy var moreTableView: MainTableView = {
        let tableView = MainTableView(frame: MainBounds, style: .plain, dataSource: self, delegate: self)
        tableView.rowHeight = DetailCellHeight
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: NavigationH, right: 0)
        tableView.register(UINib(nibName: "DetailCell", bundle: nil), forCellReuseIdentifier: SD_DetailCell_Identifier)
        return tableView
        }()
    
    fileprivate lazy var shareView: ShareView? = {
        let shareView = ShareView.shareViewFromXib()
        return shareView
        }()
    
    fileprivate lazy var webView: UIWebView? = {
        let web = UIWebView(frame: MainBounds)
        web.backgroundColor = theme.SDBackgroundColor
        web.delegate = self
        return web
        }()
    fileprivate var modalBtn: UIButton! = UIButton()
    
    /// Function
    fileprivate func setUpUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(backView)
        backView.addSubview(moreTableView)
        backView.addSubview(webView!)
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "share_1", highlImageName: "share_2", targer: self, action: #selector(ThemeViewController.shareClick))
    }
    
    fileprivate func loadMore() {
        weak var tmpSelf = self
        DetailModel.loadMore { (data, error) -> () in
            if error != nil {
                SVProgressHUD.showError(withStatus: "网络不给力")
                return
            }
            tmpSelf!.more = data!
            tmpSelf!.moreTableView.reloadData()
        }
    }
    
    fileprivate func addModalBtn() {
        let modalWH: CGFloat = NavigationH
        modalBtn.frame = CGRect(x: 10, y: AppHeight - modalWH - 10 - NavigationH, width: modalWH, height: modalWH)
        modalBtn.setImage(UIImage(named: "themelist"), for: UIControlState())
        modalBtn.setImage(UIImage(named: "themeweb"), for: .selected)
        modalBtn.addTarget(self, action: #selector(ThemeViewController.modalClick(_:)), for: .touchUpInside)
        view.addSubview(modalBtn)
    }
    
    ///MARK: - ButtonAction
    func shareClick() {
        view.addSubview(shareView!)
        shareView!.showShareView(CGRect(x: 0, y: AppHeight - 215 - 64, width: AppWidth, height: 215))
        shareView!.shareVC = self
    }
    
    func modalClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            UIView.transition(from: webView!, to: moreTableView, duration: 1.0, options: UIViewAnimationOptions.transitionFlipFromLeft, completion:nil)
        } else {
            UIView.transition(from: moreTableView, to: webView!, duration: 1.0, options: UIViewAnimationOptions.transitionFlipFromRight, completion: nil)
        }
    }
    
    /// WebViewDelegate
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.webView!.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        modalBtn.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        modalBtn.isHidden = false
    }
}

// MARK TableView的代理方法
extension ThemeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return more?.list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SD_DetailCell_Identifier) as! DetailCell
        let everyModel = more!.list![indexPath.row]
        cell.model = everyModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = more!.list![indexPath.row]
        let eventVC = EventViewController()
        eventVC.model = model
        navigationController!.pushViewController(eventVC, animated: true)
    }
}




