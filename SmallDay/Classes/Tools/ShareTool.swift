//
//  ShareTool.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/8/31.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  分享工具,新浪SSOren认证, 微信,微信朋友圈分享必须在真机上才能运行

import UIKit

class ShareTool: NSObject {
    
    class func shareToSina(_ model: ShareModel, viewController: UIViewController?)  {
        let image: UIImage = UIImage(named: "author")!
        // 新浪的连接直接写入到分享文字中就行
        UMSocialControllerService.default().setShareText(model.shareDetail! + theme.JianShuURL, shareImage: image, socialUIDelegate: nil)
        UMSocialSnsPlatformManager.getSocialPlatform(withName: UMShareToSina).snsClickHandler(viewController, UMSocialControllerService.default(), true)
    }
    
    class func shareToWeChat(_ model: ShareModel) {

        UMSocialData.default().extConfig.wechatSessionData.url = theme.JianShuURL
        UMSocialData.default().extConfig.wechatSessionData.title = model.shareTitle
        
        let image: UIImage = UIImage(named: "author")!
        let shareURL = UMSocialUrlResource(snsResourceType: UMSocialUrlResourceTypeImage, url: model.shareURL)
        
        UMSocialDataService.default().postSNS(withTypes: [UMShareToWechatSession], content: model.shareDetail, image: image, location: nil, urlResource: shareURL, presentedController: nil) { (response) -> Void in
            if response?.responseCode.rawValue == UMSResponseCodeSuccess.rawValue {
                SVProgressHUD.showSuccess(withStatus: "分享成功")
            }
        }
    }
    
    class func shareToWeChatFriends(_ model: ShareModel) {
        
        UMSocialData.default().extConfig.wechatSessionData.url = theme.JianShuURL
        UMSocialData.default().extConfig.wechatSessionData.title = model.shareTitle
        
        let image: UIImage = UIImage(named: "author")!
        let shareURL = UMSocialUrlResource(snsResourceType: UMSocialUrlResourceTypeImage, url: model.shareURL)
        
        UMSocialDataService.default().postSNS(withTypes: [UMShareToWechatTimeline], content: model.shareTitle, image: image, location: nil, urlResource: shareURL, presentedController: nil) { (response) -> Void in
            if response?.responseCode.rawValue == UMSResponseCodeSuccess.rawValue {
                SVProgressHUD.showSuccess(withStatus: "分享成功")
            }
        }
    }
    
}
