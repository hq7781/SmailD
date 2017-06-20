//
//  FeedbackViewController.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/8/20.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  用户反馈ViewController

import UIKit

class FeedbackViewController: UIViewController, UITextFieldDelegate {
    /// 反馈留言TextView
    fileprivate var feedbackTextView: UITextView!
    /// 联系方式textField
    fileprivate var contactTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置导航条上的内容
        setNav()
        
        view.backgroundColor = theme.SDWebViewBacagroundColor
        // 设置留言框和联系框
        setFeedbackTextViewAndContactTextField()
    }
    
    fileprivate func setNav() {
        self.navigationItem.title = "留言反馈"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.done, target: self, action: #selector(FeedbackViewController.sendClick))
    }
    
    fileprivate func setFeedbackTextViewAndContactTextField() {
        let backView = UIView(frame: CGRect(x: 0, y: 5, width: AppWidth, height: 130))
        backView.backgroundColor = theme.SDBackgroundColor
        feedbackTextView = UITextView(frame: CGRect(x: 5, y: 0, width: AppWidth - 10, height: 130))
        feedbackTextView.backgroundColor = theme.SDBackgroundColor
        feedbackTextView.font = UIFont.systemFont(ofSize: 20)
        feedbackTextView.allowsEditingTextAttributes = true
        feedbackTextView.autocorrectionType = UITextAutocorrectionType.no
        backView.addSubview(feedbackTextView!)
        view.addSubview(backView)
        
        contactTextField = UITextField(frame: CGRect(x: 0, y: feedbackTextView.frame.maxY + 10, width: AppWidth, height: 50))
        contactTextField.clearButtonMode = UITextFieldViewMode.always
        contactTextField.backgroundColor = theme.SDBackgroundColor
        contactTextField.font = UIFont.systemFont(ofSize: 18)
        let leffView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        contactTextField.leftView = leffView
        contactTextField.leftViewMode = UITextFieldViewMode.always
        contactTextField.placeholder = "留下邮箱或电话,以方便我们给你回复"
        contactTextField.autocorrectionType = UITextAutocorrectionType.no
        contactTextField.delegate = self
        view.addSubview(contactTextField)
    }
    
    func sendClick() {
        let contactStr = contactTextField.text
        var alartView: UIAlertView?
        
        if feedbackTextView.text.isEmpty {
            alartView = UIAlertView(title: "提示", message: "请填写您的留言反馈", delegate: nil, cancelButtonTitle: "确定")
            alartView?.show()
            return
        }
        
        if contactStr!.validateEmail() || contactStr!.validateMobile() {
            // TODO 将用户反馈和联系方式发送给服务器
            alartView = UIAlertView(title: "提示", message: "感谢您的反馈", delegate: nil, cancelButtonTitle: "确定")
            alartView?.show()
            self.navigationController?.popViewController(animated: true)
            return
        } else {
            alartView = UIAlertView(title: "提示", message: "请填写正确的联系方式,以便我们给您回复", delegate: nil, cancelButtonTitle: "确定")
            alartView?.show()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        feedbackTextView.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendClick()
        return true
    }
    
    deinit {
        print("反馈留言ViewController被销毁了", terminator: "")
    }
}


