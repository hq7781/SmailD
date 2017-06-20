//
//  DetailViewController.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/8/28.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  体验详情ViewController
//  方法一:在Xcode中解决,在返回的html数据请求前,改变所有图片的尺寸,适配到正常尺寸  缺点:重新过滤字符串的时候挺麻烦的,每次加载都要重新加载图片,费流量
//  方法二:自己写css文件来布局(推荐)
//  方法三:拦截所有的图片请求,于js配合,将请求路径给到程序里 用正常模式来加载,可以点击,缓存等等(功能更加强大,可随意自定义,设置placeHolder图片等等)

import UIKit
/// 详情ViewController顶部图片的高度
public let DetailViewController_TopImageView_Height: CGFloat = 225

class DetailViewController: UIViewController, UIActionSheetDelegate {
    // 优化性能,防止重复设置
    fileprivate var showBlackImage: Bool = false
    fileprivate var htmlNewString: NSMutableString?
    fileprivate let scrollShowNavH: CGFloat = DetailViewController_TopImageView_Height - NavigationH
    fileprivate let imageW: CGFloat = AppWidth - 23.0
    fileprivate var signUpBtn: UIButton!
    fileprivate var isLoadFinish = false
    fileprivate var isAddBottomView = false
    fileprivate var loadFinishScrollHeihgt: CGFloat = 0
    fileprivate lazy var bottomViews: [ExploreBottomView] = [ExploreBottomView]()
    fileprivate lazy var shareView: ShareView = ShareView.shareViewFromXib()
    fileprivate lazy var backBtn: UIButton = UIButton()
    fileprivate lazy var likeBtn: UIButton = UIButton()
    fileprivate lazy var sharedBtn: UIButton = UIButton()
    fileprivate lazy var webView: UIWebView = ExperienceWebView(frame: MainBounds, webViewDelegate: self, webViewScrollViewDelegate: self)
    
    fileprivate lazy var topImageView: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: AppWidth, height: DetailViewController_TopImageView_Height))
        image.image = UIImage(named: "quesheng")
        image.contentMode = UIViewContentMode.scaleToFill
        return image
        }()
    
    fileprivate lazy var phoneActionSheet: UIActionSheet? = {
        let action = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: self.model!.telephone!)
        return action
        }()
    
    fileprivate lazy var customNav: UIView = {
        let customNav = UIView(frame: CGRect(x: 0, y: 0, width: AppWidth, height: NavigationH))
        customNav.backgroundColor = UIColor.white
        customNav.alpha = 0.0
        return customNav
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        
        setCustomNavigationItem()
        
        setUpBottomView()
    }
    
    fileprivate func setUpBottomView() {
        // 添加底部报名View
        let bottomView = UIView(frame: CGRect(x: 0, y: AppHeight - 49, width: AppWidth, height: 49))
        bottomView.backgroundColor = UIColor.white
        view.addSubview(bottomView)
        
        signUpBtn = UIButton()
        signUpBtn.setBackgroundImage(UIImage(named: "registration_1"), for: UIControlState())
        signUpBtn.frame = CGRect(x: (AppWidth - 158) * 0.5, y: (49 - 36) * 0.5, width: 158, height: 36)
        signUpBtn.setTitle("报 名", for: UIControlState())
        signUpBtn.setTitleColor(UIColor.white, for: UIControlState())
        signUpBtn.addTarget(self, action: #selector(DetailViewController.signUpBtnClick), for: .touchUpInside)
        bottomView.addSubview(signUpBtn)
    }
    
    fileprivate func setUpUI() {
        view.backgroundColor = theme.SDWebViewBacagroundColor
        view.addSubview(webView)
        view.addSubview(topImageView)
        view.clipsToBounds = true
    }
    
    fileprivate func setCustomNavigationItem() {
        view.addSubview(customNav)
        //添加返回按钮
        setButton(backBtn, CGRect(x: -7, y: 20, width: 44, height: 44), "back_0", "back_2", #selector(DetailViewController.backButtonClick))
        view.addSubview(backBtn)
        // 添加收藏按钮
        setButton(likeBtn, CGRect(x: AppWidth - 105, y: 20, width: 44, height: 44), "collect_0", "collect_0", #selector(DetailViewController.lickBtnClick))
        likeBtn.setImage(UIImage(named: "collect_2"), for: .selected)
        view.addSubview(likeBtn)
        // 添加分享按钮
        setButton(sharedBtn, CGRect(x: AppWidth - 54, y: 20, width: 44, height: 44), "share_0", "share_2", #selector(DetailViewController.sharedBtnClick))
        view.addSubview(sharedBtn)
    }
    
    fileprivate func setButton(_ btn: UIButton, _ frame: CGRect, _ imageName: String, _ highlightedImageName: String, _ action: Selector) {
        btn.frame = frame
        btn.setImage(UIImage(named: imageName), for: UIControlState())
        btn.setImage(UIImage(named: highlightedImageName), for: .highlighted)
        btn.addTarget(self, action: action, for: .touchUpInside)
    }
    
    /// model重写didSet方法
    var model: EventModel? {
        didSet {
            self.webView.isHidden = true
            if let imageStr = model?.imgs?.last {
                self.topImageView.wxn_setImageWithURL(URL(string: imageStr)! as NSURL, placeholderImage: UIImage(named: "quesheng")!)
            }
            self.shareView.shareModel = ShareModel(shareTitle: model?.title, shareURL: model?.shareURL, image: nil, shareDetail: model?.detail)
            var htmlSrt = model?.mobileURL
            
            if htmlSrt != nil {
                var titleStr: String?
                
                if model?.title != nil {
                    titleStr = String(format: "<p style='font-size:20px;'> %@</p>", model!.title!)
                }
                
                if model?.tag != nil {
                    titleStr = titleStr?.appendingFormat("<p style='font-size:13px; color: gray';>%@</p>", model!.tag!)
                }
                
                if titleStr != nil {
                    let newStr: NSMutableString = NSMutableString(string: htmlSrt!)
                    newStr.insert(titleStr!, at: 31)
                    htmlSrt = newStr as String
                }
                
                htmlNewString = NSMutableString.changeHeigthAndWidthWithSrting(NSMutableString(string: htmlSrt!))
            }
            
            webView.loadHTMLString(htmlNewString! as String, baseURL: nil)
            webView.scrollView.setContentOffset(CGPoint(x: 0, y: -DetailViewController_TopImageView_Height + 20), animated: false)
            self.webView.isHidden = false
            
            // 根据模型按条件添加webView底部的view
            if model!.questionURL != "" && model!.questionURL != nil {
                bottomViews.append(ExploreBottomView.exploreBottomViewFromXib("价格", subTitle: "购买须知", target: self, action: #selector(DetailViewController.priceBottomClick(_:)), showBtn: false, showArrow: true))
            }
            
            bottomViews.append(ExploreBottomView.exploreBottomViewFromXib("提醒", subTitle: "每天", target: self, action: #selector(DetailViewController.remindViewClick(_:)), showBtn: true, showArrow: false))
            
            if model!.telephone != nil && model!.telephone != "" {
                bottomViews.append(ExploreBottomView.exploreBottomViewFromXib("电话", subTitle: model!.telephone!, target: self, action: #selector(DetailViewController.telephoneBottomClick(_:)), showBtn: false, showArrow: true))
            }
            
            if model!.position != nil && model!.position != "" && model!.address != nil && model!.address != "" {
                bottomViews.append(ExploreBottomView.exploreBottomViewFromXib("地址", subTitle: model!.address!, target: self, action: #selector(DetailViewController.addressBottomClick(_:)), showBtn: false, showArrow: true))
            }
        }
    }
    /// MARK:- 底部添加的view的四种状态点击action
    /// 购买详情
    func priceBottomClick(_ tap: UITapGestureRecognizer) {
        let buyVC = BuyDetailViewController()
        buyVC.htmlStr = model!.questionURL
        navigationController!.pushViewController(buyVC, animated: true)
    }
    
    /// 提醒
    func remindViewClick(_ tap: UITapGestureRecognizer) {
        print("提醒", terminator: "")
    }
    
    /// 电话
    func telephoneBottomClick(_ tap: UITapGestureRecognizer) {
        phoneActionSheet?.show(in: view)
    }
    
    /// 地址
    func addressBottomClick(_ tap: UITapGestureRecognizer) {
        let navVC = NavigatorViewController()
        navVC.model = model
        navigationController?.pushViewController(navVC, animated: true)
    }
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 0 {
            let url = URL(string: "tel://" + model!.telephone!)
            UIApplication.shared.openURL(url!)
        }
    }
    
    deinit {
        print("体验详情ViewController已经销毁", terminator: "")
    }
}

/// MARK:- 所有按钮的事件
extension DetailViewController {
    /// 返回
    func backButtonClick() {
        navigationController!.popViewController(animated: true)
    }
    
    /// 收藏
    func lickBtnClick() {
        likeBtn.isSelected = !likeBtn.isSelected
    }
    
    /// 分享
    func sharedBtnClick() {
        view.addSubview(shareView)
        shareView.shareVC = self
        shareView.showShareView(CGRect(x: 0, y: AppHeight - 215, width: AppWidth, height: 215))
    }
    
    /// 报名
    func signUpBtnClick() {
        let suVC = SignUpViewController()
        navigationController!.pushViewController(suVC, animated: true)
        suVC.topTitle = model!.title
    }
    
}

/// MARK:- 处理导航条显示消失
extension DetailViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController!.setNavigationBarHidden(true, animated: true)
        if isLoadFinish && isAddBottomView {
            webView.scrollView.contentSize.height = loadFinishScrollHeihgt
        }
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController!.setNavigationBarHidden(false, animated: true)
        super.viewWillDisappear(animated)
    }
}

/// MARK:- 处理内容滚动时的事件
extension DetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY: CGFloat = scrollView.contentOffset.y
        
        // 解决弹出新的控制器后返回后contentSize自动还原的问题
        if loadFinishScrollHeihgt > webView.scrollView.contentSize.height && scrollView === webView.scrollView {
            webView.scrollView.contentSize.height = loadFinishScrollHeihgt
        }
        
        // 加标记的作用为了优化性能
        // 判断顶部自定义导航条的透明度,以及图片的切换
        customNav.alpha = 1 + (offsetY + NavigationH) / scrollShowNavH
        if offsetY >= -NavigationH && showBlackImage == false {
            backBtn.setImage(UIImage(named: "back_1"), for: UIControlState())
            likeBtn.setImage(UIImage(named: "collect_1"), for: UIControlState())
            sharedBtn.setImage(UIImage(named: "share_1"), for: UIControlState())
            showBlackImage = true
        } else if offsetY < -NavigationH && showBlackImage == true {
            backBtn.setImage(UIImage(named: "back_0"), for: UIControlState())
            likeBtn.setImage(UIImage(named: "collect_0"), for: UIControlState())
            sharedBtn.setImage(UIImage(named: "share_0"), for: UIControlState())
            showBlackImage = false
        }
        
        // 顶部imageView的跟随动画
        if offsetY <= -DetailViewController_TopImageView_Height {
            topImageView.frame.origin.y = 0
            topImageView.frame.size.height = -offsetY
            topImageView.frame.size.width = AppWidth - offsetY - DetailViewController_TopImageView_Height
            topImageView.frame.origin.x = (0 + DetailViewController_TopImageView_Height + offsetY) * 0.5
        } else {
            topImageView.frame.origin.y = -offsetY - DetailViewController_TopImageView_Height
        }
        
        if isLoadFinish && !isAddBottomView && scrollView.contentSize.height > AppHeight  {
            isAddBottomView = true
            for bottomView in bottomViews {
                let bottomViewH = bottomView.bottomLineView.frame.maxY
                bottomView.frame = CGRect(x: 0, y: webView.scrollView.contentSize.height, width: AppWidth, height: bottomViewH)
                webView.scrollView.addSubview(bottomView)
                webView.scrollView.contentSize.height += bottomViewH
            }
            scrollView.contentSize.height += 20
            loadFinishScrollHeihgt = scrollView.contentSize.height
        }
    }
}

/// MARK: UIWebViewDelegate
extension DetailViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('body')[0].style.background='#F5F5F5';")
        webView.isHidden = false
        isLoadFinish = true
    }
}



