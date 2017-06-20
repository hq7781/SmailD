//
//  LoginViewController.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/8/20.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  登陆控制器

import UIKit

public let SD_UserLogin_Notification = "SD_UserLogin_Notification"
public let SD_UserDefaults_Account = "SD_UserDefaults_Account"
public let SD_UserDefaults_Password = "SD_UserDefaults_Password"

class LoginViewController: UIViewController, UIScrollViewDelegate {
    
    var bottomView: UIView!
    var backScrollView: UIScrollView!
    var topView: UIView!
    var phoneTextField: UITextField!
    var psdTextField: UITextField!
    var loginImageView: UIImageView!
    var quickLoginBtn: UIButton!
    var forgetPwdImageView: UIImageView!
    var registerImageView: UIImageView!
    let textCoclor: UIColor = UIColor.colorWith(50, green: 50, blue: 50, alpha: 1)
    let loginW: CGFloat = 250
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "登录"
        view.backgroundColor = theme.SDWebViewBacagroundColor
        //添加scrollView
        addScrollView()
        // 添加手机文本框和密码文本框
        addTextField()
        // 添加登录View
        addLoginImageView()
        // 添加快捷登录按钮
        addQuictLoginBtn()
        // 添加底部忘记密码和注册view
        addBottomView()
        // 添加键盘通知
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillChangeFrameNotification(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func addScrollView() {
        backScrollView = UIScrollView(frame: view.bounds)
        backScrollView.backgroundColor = theme.SDWebViewBacagroundColor
        backScrollView.alwaysBounceVertical = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.backScrollViewTap))
        backScrollView.addGestureRecognizer(tap)
        view.addSubview(backScrollView)
    }
    
    func addLoginImageView() {
        let loginH: CGFloat = 50
        loginImageView = UIImageView(frame: CGRect(x: (AppWidth - loginW) * 0.5, y: topView!.frame.maxY + 10, width: loginW, height: loginH))
        loginImageView.isUserInteractionEnabled = true
        loginImageView.image = UIImage(named: "signin_1")
        
        let loginLabel = UILabel(frame: loginImageView.bounds)
        loginLabel.text = "登  录"
        loginLabel.textAlignment = .center
        loginLabel.textColor = textCoclor
        loginLabel.font = UIFont.systemFont(ofSize: 22)
        loginImageView.addSubview(loginLabel)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.loginClick))
        loginImageView.addGestureRecognizer(tap)
        
        backScrollView.addSubview(loginImageView)
    }
    
    func addTextField() {
        let textH: CGFloat = 55
        let leftMargin: CGFloat = 10
        let alphaV: CGFloat = 0.2
        topView = UIView(frame: CGRect(x: 0, y: 20, width: AppWidth, height: textH * 2))
        topView?.backgroundColor = UIColor.white
        backScrollView.addSubview(topView!)
        
        let line1 = UIView(frame: CGRect(x: 0, y: 0, width: AppWidth, height: 1))
        line1.backgroundColor = UIColor.gray
        line1.alpha = alphaV
        topView!.addSubview(line1)
        
        phoneTextField = UITextField()
        phoneTextField?.keyboardType = UIKeyboardType.numberPad
        addTextFieldToTopViewWiht(phoneTextField!, frame: CGRect(x: leftMargin, y: 1, width: AppWidth - leftMargin, height: textH - 1), placeholder: "请输入手机号")
        
        let line2 = UIView(frame: CGRect(x: 0, y: textH, width: AppWidth, height: 1))
        line2.backgroundColor = UIColor.gray
        line2.alpha = alphaV
        topView!.addSubview(line2)
        
        psdTextField = UITextField()
        addTextFieldToTopViewWiht(psdTextField!, frame: CGRect(x: leftMargin, y: textH + 1, width: AppWidth - leftMargin, height: textH - 1), placeholder: "密码")
    }
    
    func addQuictLoginBtn() {
        quickLoginBtn = UIButton()
        quickLoginBtn.setTitle("无账号快捷登录", for: UIControlState())
        quickLoginBtn.titleLabel?.sizeToFit()
        quickLoginBtn.contentMode = .right
        let quickW: CGFloat = quickLoginBtn.titleLabel!.width
        quickLoginBtn.frame = CGRect(x: AppWidth - quickW - 10, y: loginImageView.frame.maxY + 10, width: quickW, height: 30)
        quickLoginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        quickLoginBtn.addTarget(self, action: #selector(LoginViewController.quickLoginClick), for: .touchUpInside)
        quickLoginBtn.setTitle("无账号快捷登录", for: UIControlState())
        quickLoginBtn.setTitleColor(textCoclor, for: UIControlState())
        quickLoginBtn.setTitleColor(UIColor.lightGray, for: .highlighted)
        backScrollView.addSubview(quickLoginBtn)
    }
    
    func addTextFieldToTopViewWiht(_ textField: UITextField ,frame: CGRect, placeholder: String) {
        textField.frame = frame
        textField.autocorrectionType = .no
        textField.clearButtonMode = .always
        textField.backgroundColor = UIColor.white
        textField.placeholder = placeholder
        topView!.addSubview(textField)
    }
    
    func addBottomView() {
        let forgetPwdImageViewH: CGFloat = 45
        
        bottomView = UIView(frame: CGRect(x: (AppWidth - loginW) * 0.5, y: AppHeight - forgetPwdImageViewH - 10 - 64, width: loginW, height: forgetPwdImageViewH))
        bottomView.backgroundColor = UIColor.clear
        backScrollView.addSubview(bottomView)
        
        forgetPwdImageView = UIImageView()
        addBottomViewWithImageView(forgetPwdImageView, tag: 10, frame: CGRect(x: 0, y: 0, width: loginW * 0.5, height: forgetPwdImageViewH), imageName: "c1_1", title: "忘记密码")
        
        registerImageView = UIImageView()
        addBottomViewWithImageView(registerImageView, tag: 11, frame: CGRect(x: bottomView.width * 0.5, y: 0, width: loginW * 0.5, height: forgetPwdImageViewH), imageName: "c1_2", title: "注册")
    }
    
    func addBottomViewWithImageView(_ imageView: UIImageView, tag: Int, frame: CGRect, imageName: String, title: String) {
        imageView.frame = frame
        imageView.image = UIImage(named: imageName)
        imageView.tag = tag
        imageView.isUserInteractionEnabled = true
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: imageView.width, height: imageView.height))
        label.textAlignment = .center
        label.textColor = textCoclor
        label.text = title
        label.font = UIFont.systemFont(ofSize: 15)
        imageView.addSubview(label)
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.bottomViewColcikWith(_:)))
        imageView.addGestureRecognizer(tap)
        
        bottomView.addSubview(imageView)
        
    }
    
    /// 底部忘记密码和注册按钮点击
    func bottomViewColcikWith(_ tap: UIGestureRecognizer) {
        if tap.view!.tag == 10 { // 忘记密码
            print("忘记密码", terminator: "")
        } else {                 // 注册
            print("注册", terminator: "")
            SVProgressHUD.showError(withStatus: "直接登录就行...没有注册功能", maskType: .black)
        }
    }
    
    /// 登录按钮被点击
    func loginClick() {
        
        if !phoneTextField.text!.validateMobile() {
            SVProgressHUD.showError(withStatus: "请输入11位的正确手机号", maskType: SVProgressHUDMaskType.black)
            return
        } else if psdTextField.text!.isEmpty {
            SVProgressHUD.showError(withStatus: "密码不能为空", maskType: SVProgressHUDMaskType.black)
            return
        }
        
        //将用户的账号和密码暂时保存到本地,实际开发中光用MD5加密是不够的,需要多重加密
        let account = phoneTextField.text
        let psdMD5 = psdTextField.text!.md5
        UserDefaults.standard.set(account, forKey: SD_UserDefaults_Account)
        UserDefaults.standard.set(psdMD5, forKey: SD_UserDefaults_Password)
        if UserDefaults.standard.synchronize() {
            navigationController?.popViewController(animated: true)
        }
    }
    
    /// 快捷登录点击
    func quickLoginClick() {
        print("快捷登陆", terminator: "")
    }
    
    func keyboardWillChangeFrameNotification(_ note: Notification) {
        // TODO 添加键盘弹出的事件
        let userinfo = note.userInfo!
        let rect = (userinfo[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue
        var boardH = AppHeight - (rect?.origin.y)!
        if boardH > 0 {
            boardH = boardH + NavigationH
        }
        backScrollView.contentSize = CGSize(width: 0, height: view.height + boardH)
    }
    
    func backScrollViewTap() {
        view.endEditing(true)
    }
}
