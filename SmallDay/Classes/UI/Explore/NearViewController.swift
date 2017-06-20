//
//  NearViewController.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/8/16.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  附近控制器

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class NearViewController: UIViewController {
    // MARK:- 懒加载对象
    fileprivate var nears: DetailModel?
    
    fileprivate lazy var backView:UIView = {
        let backView = UIView(frame: self.view.bounds)
        backView.backgroundColor = theme.SDBackgroundColor
        return backView
        }()
    
    fileprivate lazy var nearTableView: MainTableView = {
        let tableV = MainTableView(frame: MainBounds, style: .plain, dataSource: self, delegate: self)
        tableV.rowHeight = DetailCellHeight
        tableV.register(UINib(nibName: "DetailCell", bundle: nil), forCellReuseIdentifier: SD_DetailCell_Identifier)
        
        let diyHeader = SDRefreshHeader(refreshingTarget: self, refreshingAction: #selector(NearViewController.pullLoadDatas))
        // Compile error! diyHeader.gifView!.frame = CGRect(x: (AppWidth - SD_RefreshImage_Width) * 0.5, y: 10, width: SD_RefreshImage_Width, height: SD_RefreshImage_Height)
        tableV.header = diyHeader
        return tableV
        }()
    
    fileprivate lazy var mapView: WNXMapView = WNXMapView(frame: self.view.bounds)
    
    fileprivate lazy var rightItem: UIBarButtonItem = {
        let right = UIBarButtonItem(image:UIImage(named:"map_2-1"), landscapeImagePhone: UIImage(named: "map_2"), style: .plain, target: self, action: #selector(NearViewController.leftItemClick(_:))) //style "list_1")

        return right
        }()
    
    // MARK:- 方法
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(backView)
        
        title = "附近"
        view.backgroundColor = theme.SDBackgroundColor
        backView.addSubview(nearTableView)
        
        // 加载附近是否有店铺, 这里就定位到了我的附近,在深圳,模拟一直有附近,数据是本地的,所以获取的是固定的
        nearTableView.header.beginRefreshing()
        nearTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0)
    }
    
    func pullLoadDatas() {
        weak var tmpSelf = self
        let time = DispatchTime.now() + Double(Int64(0.8 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) { () -> Void in
            DetailModel.loadNearDatas({ (data, error) -> () in
                if error != nil {
                    SVProgressHUD.showError(withStatus: "网速不给力")
                    tmpSelf!.nearTableView.header.endRefreshing()
                    return
                }
                
                tmpSelf!.nears = data
                tmpSelf!.nearTableView.reloadData()
                tmpSelf!.nearTableView.header.endRefreshing()
                tmpSelf!.mapView.nearsModel = data
                tmpSelf!.addMapView()
            })
        }
    }
    
    fileprivate func addMapView() {
        mapView.pushVC = self
        backView.insertSubview(mapView, belowSubview: nearTableView)
    }
    
    
    
    func leftItemClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            UIView.transition(from: nearTableView, to: mapView, duration: 1.0, options: UIViewAnimationOptions.transitionFlipFromLeft, completion: nil)
        } else {
            UIView.transition(from: mapView, to: nearTableView, duration: 1.0, options: UIViewAnimationOptions.transitionFlipFromRight, completion: nil)
        }
    }
    
    deinit {
        mapView.clearDisk()
        mapView.isShowsUserLocation = false
        print("地图控制器被销毁", terminator: "")
    }
}

//MARK:- TableView代理方法
extension NearViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if nears?.list?.count > 0 {
            navigationItem.rightBarButtonItem = rightItem
        } else {
            navigationItem.rightBarButtonItem = nil
        }
        
        return nears?.list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SD_DetailCell_Identifier) as? DetailCell
        cell!.model = nears!.list![indexPath.row] as EventModel
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventModel = nears!.list![indexPath.row] as EventModel
        let detailVC = EventViewController()
        detailVC.model = eventModel
        navigationController!.pushViewController(detailVC, animated: true)
    }
}
