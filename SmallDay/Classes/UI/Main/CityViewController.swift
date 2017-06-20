//
//  CityViewController.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/8/16.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//

import UIKit

public let SD_Current_SelectedCity = "SD_Current_SelectedCity"
public let SD_CurrentCityChange_Notification = "SD_CurrentCityChange_Notification"

class CityViewController: UIViewController {
    var cityName: String?
    var collView: UICollectionView!
    var layout = UICollectionViewFlowLayout()
    
    lazy var domesticCitys: NSMutableArray? = {
        let arr = NSMutableArray(array: ["北京", "上海", "成都", "广州", "杭州", "西安", "重庆", "厦门", "台北"])
        return arr
        }()
    lazy var overseasCitys: NSMutableArray? = {
        let arr = NSMutableArray(array: ["罗马", "迪拜", "里斯本", "巴黎", "柏林", "伦敦"])
        return arr
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNav()
        
        setCollectionView()
        
        let lastSelectedCityIndexPaht = selectedCurrentCity()
        collView.selectItem(at: lastSelectedCityIndexPaht, animated: true, scrollPosition: UICollectionViewScrollPosition())
    }
    
    fileprivate func selectedCurrentCity() -> IndexPath {
        if let currentCityName = self.cityName {
            for i in 0 ..< domesticCitys!.count {
                if currentCityName == domesticCitys![i] as! String {
                    return IndexPath(item: i, section: 0)
                }
            }
            
            for i in 0 ..< overseasCitys!.count {
                if currentCityName == overseasCitys![i] as! String {
                    return IndexPath(item: i, section: 1)
                }
            }
        }
        
        return IndexPath(item: 0, section: 0)
    }
    
    func setNav() {
        view.backgroundColor = theme.SDBackgroundColor
        navigationItem.title = "选择城市"
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", titleClocr: UIColor.blackColor(), targer: self, action: "cancle")
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .done, target: self, action: #selector(CityViewController.cancle))
    }
    
    func setCollectionView() {
        // 设置布局
        let itemW = AppWidth / 3.0 - 1.0
        let itemH: CGFloat = 50
        layout.itemSize = CGSize(width: itemW, height: itemH)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.headerReferenceSize = CGSize(width: view.width, height: 60)
        
        // 设置collectionView
        collView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collView.delegate = self
        collView.dataSource = self
        collView.selectItem(at: IndexPath(item: 1, section: 0), animated: true, scrollPosition: UICollectionViewScrollPosition())
        collView.backgroundColor = UIColor.colorWith(247, green: 247, blue: 247, alpha: 1)
        collView.register(CityCollectionViewCell.self, forCellWithReuseIdentifier: "cellID")
        collView.register(CityHeadCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headView")
        collView.register(CityFootCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footView")
        collView.alwaysBounceVertical = true
        
        view.addSubview(collView!)
    }
    
    func cancle() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}



// MARK - UICollectionViewDelegate, UICollectionViewDataSource
extension CityViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return domesticCitys!.count
        } else {
            return overseasCitys!.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! CityCollectionViewCell
        if indexPath.section == 0 {
            cell.cityName = domesticCitys!.object(at: indexPath.row) as? String
        } else {
            cell.cityName = overseasCitys!.object(at: indexPath.row) as? String
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionFooter && indexPath.section == 1 {
            let footView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footView", for: indexPath) as! CityFootCollectionReusableView
            footView.frame.size.height = 80
            return footView
        }
        
        let headView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headView", for: indexPath) as! CityHeadCollectionReusableView
        
        if indexPath.section == 0 {
            headView.headTitle = "国内城市"
        } else {
            headView.headTitle = "国外城市"
        }

        return headView
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 拿出当前选择的cell
        let cell = collectionView.cellForItem(at: indexPath) as! CityCollectionViewCell
        let currentCity = cell.cityName
        let user = UserDefaults.standard
        user.set(currentCity, forKey: SD_Current_SelectedCity)
        if user.synchronize() {
            NotificationCenter.default.post(name: Notification.Name(rawValue: SD_CurrentCityChange_Notification), object: currentCity)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    /// 这方法是UICollectionViewDelegateFlowLayout 协议里面的， 我现在是 默认的flow layout， 没有自定义layout，所以就没有实现UICollectionViewDelegateFlowLayout协议,需要完全手敲出来方法,对应的也有设置header的尺寸方法
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize.zero
        } else {
            return CGSize(width: view.width, height: 120)
        }
    }
    
}



