//
//  ShakeViewController.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/8/21.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  摇一摇控制器

import UIKit
import AVFoundation

class ShakeViewController: UIViewController {
    var detailModel: DetailModel?
    fileprivate lazy var soundID: SystemSoundID? = {
        let url = Bundle.main.url(forResource: "glass.wav", withExtension: nil)
        let urlRef: CFURL = url! as CFURL
        var id: SystemSoundID = 100
        AudioServicesCreateSystemSoundID(urlRef, &id)
        return id
        }()
    
    fileprivate lazy var foodView: UIView? = {
        let foodView = UIView(frame: CGRect(x: 0, y: 0, width: AppWidth, height: 80))
        foodView.backgroundColor = UIColor.clear
        let button = UIButton(frame: CGRect(x: (AppWidth - 120) * 0.5, y: 20, width: 120, height: 40))
        button.setBackgroundImage(UIImage(named: "fsyzm"), for: UIControlState())
        button.setTitle("在摇一次", for: UIControlState())
        button.setTitleColor(UIColor.black, for: UIControlState())
        button.addTarget(self, action: #selector(ShakeViewController.aginButtonClick), for: .touchUpInside)
        foodView.addSubview(button)
        return foodView
        }()
    
    @IBOutlet weak fileprivate var yaoImageView1: UIImageView!
    @IBOutlet weak fileprivate var yaoImageView2: UIImageView!
    @IBOutlet weak fileprivate var bottomLoadView: UIView!
    
    fileprivate lazy var tableView: UITableView? = {
        let tableView = UITableView(frame: MainBounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.rowHeight = DetailCellHeight
        tableView.contentInset = UIEdgeInsetsMake(0, 0, NavigationH, 0)
        tableView.separatorStyle = .none
        tableView.tableFooterView = self.foodView
        tableView.register(UINib(nibName: "DetailCell", bundle: nil), forCellReuseIdentifier: "DetailCell")
        return tableView
        }()
    
    /// 重写构造方法,直接在xib里加载
    init() {
        super.init(nibName: "ShakeViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: "ShakeViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "摇一摇"
        view.addSubview(tableView!)
    }
    
    deinit {
        print("摇一摇控制器被销毁了", terminator: "")
    }
    
    ///MARK:- 摇一摇功能
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        tableView!.isHidden = true
        let animateDuration: TimeInterval = 0.3
        let offsetY: CGFloat = 50
        
        UIView.animate(withDuration: animateDuration, animations: { () -> Void in
            self.yaoImageView1.transform = CGAffineTransform(translationX: 0, y: -offsetY)
            self.yaoImageView2.transform = CGAffineTransform(translationX: 0, y: offsetY)
            
            }, completion: { (finish) -> Void in
                let popTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: popTime, execute: { () -> Void in
                    
                    UIView.animate(withDuration: animateDuration, animations: { () -> Void in
                        self.yaoImageView1.transform = CGAffineTransform.identity
                        self.yaoImageView2.transform = CGAffineTransform.identity
                        }, completion: { (finish) -> Void in
                            
                            self.loadShakeData()
                            // 音效
                            AudioServicesPlayAlertSound(self.soundID!)
                    })
                })
        }) 
    }
    
    fileprivate func loadShakeData() {
        bottomLoadView.isHidden = false
        let time = DispatchTime.now() + Double(Int64(1.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) { () -> Void in
            DetailModel.loadDetails({ (data, error) -> () in
                self.bottomLoadView.isHidden = true
                self.tableView!.isHidden = false
                self.detailModel = data
                self.tableView!.reloadData()
            })
        }
    }
    
    /// 再摇一次
    func aginButtonClick() {
        self.motionBegan(.motionShake, with: UIEvent())
    }
}

/// MARK: TableViewDelegate, TableViewDataSours
extension ShakeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return detailModel?.list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell") as! DetailCell
        let everyModel = detailModel!.list![indexPath.row]
        cell.model = everyModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let everyModel = detailModel!.list![indexPath.row]
        let vc = EventViewController()
        vc.model = everyModel
        navigationController!.pushViewController(vc, animated: true)
    }
    
}











