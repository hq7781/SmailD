//
//  SignUpViewController.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/8/28.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  报名ViewController

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak fileprivate var submitBtn: UIButton!
    @IBOutlet weak fileprivate var codeTextField: UITextField!
    @IBOutlet weak fileprivate var sendCodeBtn: UIButton!
    @IBOutlet weak fileprivate var phoneNumTextField: UITextField!
    @IBOutlet weak fileprivate var loginBtn: UIButton!
    @IBOutlet weak fileprivate var remarkTextField: UITextField!
    @IBOutlet weak fileprivate var titleLabel: UILabel!
    @IBOutlet weak fileprivate var nameTextField: UITextField!
    @IBOutlet weak fileprivate var scrollView: UIScrollView!
    @IBOutlet weak fileprivate var contentView: UIView!
    
    var topTitle: String?
    fileprivate var second: Int = 60
    fileprivate var timer: Timer?
    
    init() {
        super.init(nibName: "SignUpViewController", bundle: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("报名控制器被销毁", terminator: "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "报名"
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        // 从XIB中加载后的初始化
        setUpXIB()
        
    }
    
    /// 键盘frame即将改变
    func keyboardWillChangeFrame(_ noti: Notification) {
        var fristTF:UITextField?
        if nameTextField.isFirstResponder {
            fristTF = nameTextField
        } else if phoneNumTextField.isFirstResponder {
            fristTF = phoneNumTextField
        } else if codeTextField.isFirstResponder {
            fristTF = codeTextField
        }
        
        if let userInfo = noti.userInfo {
            let newF = (userInfo[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue
            let boardH = AppHeight - (newF?.origin.y)!
            let animDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey]! as! Double
            if fristTF != nil && boardH != 0 {
                let maxY = fristTF!.frame.maxY + fristTF!.superview!.frame.minY + NavigationH
                let offsetY = boardH + maxY - AppHeight
                UIView.animate(withDuration: animDuration, animations: { () -> Void in
                    self.scrollView.contentOffset = CGPoint(x: 0, y: self.positiveNumber(offsetY))
                })
            } else {
                UIView.animate(withDuration: animDuration, animations: { () -> Void in
                    self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
                })
            }
        }
    }
    
    fileprivate func setUpXIB() {
        scrollView.alwaysBounceVertical = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.scrollViewClick))
        scrollView.addGestureRecognizer(tap)
        scrollView.keyboardDismissMode = .onDrag
        titleLabel.text = topTitle
        sendCodeBtn.addTarget(self, action: #selector(SignUpViewController.sendCodeBtnClick(_:)), for: .touchUpInside)
    }
    
    func scrollViewClick() {
        view.endEditing(true)
    }
    
    fileprivate func positiveNumber(_ num: CGFloat) -> CGFloat {
        return num >= 0 ? num : -num
    }
    
    /// 发送验证码
    func sendCodeBtnClick(_ sender: UIButton) {
        if phoneNumTextField.text!.validateMobile() {
            sendCodeBtn.isEnabled = false
            self.timer = Timer(timeInterval: 1.0, target: self, selector: #selector(SignUpViewController.changeBtn), userInfo: nil, repeats: true)
            RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
            timer!.fire()
            codeTextField.becomeFirstResponder()
        } else {
            SVProgressHUD.showError(withStatus: "输入11位的正确手机号", maskType: SVProgressHUDMaskType.black)
        }
    }
    
    func changeBtn() {
        sendCodeBtn.setTitle("已发送\(second)秒", for: .disabled)
        second -= 1
        if second == 0 {
            sendCodeBtn.isEnabled = true
            timer!.invalidate()
            self.timer = nil
            second = 60
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.timer != nil {
            self.timer!.invalidate()
            self.timer = nil
        }
        
        super.viewWillDisappear(animated)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: "SignUpViewController", bundle: nil)
    }
}
