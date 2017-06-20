//
//  AppDelegate.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/8/14.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  由于Swift语言还不稳定,每个版本都会出现语法修改,本项目用最新的Xcode7正式版编写,建议使用Xcode7正式版运行工程
//  本项目之前使用的Xcode6.2编译, 9.18更新到了Xcode7,临时修改了新语法,但是针对iOS9.0只是修改了网络请求,发现在程序运行的时候会输出很多错误信息,iOS9.0多了很多变动,小熊还在研究,如有任何意见请到我的博客或者微博留言交流,小熊会在看到的第一时间回复

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setKeyWindow()
        
        setAppAppearance()
        
        setShared()
        
        setUserMapInfo()
        
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.showMianViewController), name: NSNotification.Name(rawValue: SD_ShowMianTabbarController_Notification), object: nil)
        
        return true
    }
    
    fileprivate func setKeyWindow() {
        window = UIWindow(frame: MainBounds)
        
        window?.rootViewController = showLeadpage()
        
        window?.makeKeyAndVisible()
    }
    
    func setUserMapInfo() {
        UserInfoManager.sharedUserInfoManager.startUserlocation()
        MAMapServices.shared().apiKey = theme.GaoDeAPPKey
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - 分享设置
    func setAppAppearance() {
        let itemAppearance = UITabBarItem.appearance()
        itemAppearance.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.black, NSFontAttributeName : UIFont.systemFont(ofSize: 12)], for: .selected)
        itemAppearance.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.gray, NSFontAttributeName : UIFont.systemFont(ofSize: 12)], for: UIControlState())
        
        //设置导航栏主题
        let navAppearance = UINavigationBar.appearance()
        // 设置导航titleView字体
        navAppearance.isTranslucent = false
        navAppearance.titleTextAttributes = [NSFontAttributeName : theme.SDNavTitleFont, NSForegroundColorAttributeName : UIColor.black]
        
        let item = UIBarButtonItem.appearance()
        item.setTitleTextAttributes([NSFontAttributeName : theme.SDNavItemFont, NSForegroundColorAttributeName : UIColor.black], for: UIControlState())
    }
    
    func setShared() {
        UMSocialData.setAppKey(theme.UMSharedAPPKey)
//        UMSocialSinaHandler.openSSOWithRedirectURL("http://www.jianshu.com/users/5fe7513c7a57/latest_articles")
        UMSocialSinaHandler.openSSO(withRedirectURL: nil)
        UMSocialWechatHandler.setWXAppId("wx485c6ee1758251bd", appSecret: "468ab73eef432f59a2aa5630e340862f", url: theme.JianShuURL)
        UMSocialConfig.hiddenNotInstallPlatforms([UMShareToWechatSession,UMShareToWechatTimeline])
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return UMSocialSnsService.handleOpen(url)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return UMSocialSnsService.handleOpen(url)
    }
    
    //MARK: - 引导页设置
    fileprivate func showLeadpage() -> UIViewController {
        let versionStr = "CFBundleShortVersionString"
        let cureentVersion = Bundle.main.infoDictionary![versionStr] as! String
        let oldVersion = (UserDefaults.standard.object(forKey: versionStr) as? String) ?? ""
        
        if cureentVersion.compare(oldVersion) == ComparisonResult.orderedDescending {
            UserDefaults.standard.set(cureentVersion, forKey: versionStr)
            UserDefaults.standard.synchronize()
            return LeadpageViewController()
        }
        
        return MainTabBarController()
    }
    
    func showMianViewController() {
        let mainTabBarVC = MainTabBarController()
        self.window!.rootViewController = mainTabBarVC
        let nav = mainTabBarVC.viewControllers![0] as? MainNavigationController
        (nav?.viewControllers[0] as! MainViewController).pushcityView()
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        SDWebImageManager.shared().imageCache.cleanDisk()
        SDWebImageManager.shared().cancelAll()
    }
}

