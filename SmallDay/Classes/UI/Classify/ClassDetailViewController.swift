//
//  ClassDetailViewController.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/8/25.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  分类详情控制器

import UIKit

public let DetailCellHeight: CGFloat = 220

class ClassDetailViewController: UIViewController {
    
    fileprivate lazy var detailTableView: MainTableView = {
        let tableView = MainTableView(frame: MainBounds, style: .plain, dataSource: self, delegate: self)
        tableView.rowHeight = DetailCellHeight
        tableView.contentInset = UIEdgeInsetsMake(0, 0, NavigationH, 0)
        tableView.register(UINib(nibName: "DetailCell", bundle: nil), forCellReuseIdentifier: SD_DetailCell_Identifier)
        return tableView
        }()
    
    var details: DetailModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = theme.SDBackgroundColor
        view.addSubview(detailTableView)
        
        loadDatas()
    }
    
    fileprivate func loadDatas() {
        weak var tmpSelf = self
        DetailModel.loadDetails { (data, error) -> () in
            if error != nil {
                return
            }
            tmpSelf!.details = data
            tmpSelf!.detailTableView.reloadData()
        }
    }
}


extension ClassDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details?.list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = details!.list![indexPath.row] as EventModel
        let cell = tableView.dequeueReusableCell(withIdentifier: SD_DetailCell_Identifier) as? DetailCell
        cell?.model = event
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventModel = details!.list![indexPath.row]
        let vc = EventViewController()
        vc.model = eventModel
        navigationController!.pushViewController(vc, animated: true)
    }
}
