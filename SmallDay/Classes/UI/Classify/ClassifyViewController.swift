//
//  ClassifyViewController.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/8/14.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  分类

import UIKit

class ClassifyViewController: MainViewController {
    
    fileprivate var collView: UICollectionView!
    fileprivate var headTitles: NSArray = ["闲时光·发现·惊喜", "涨知识·分享·丰盈"]
    fileprivate var classData: ClassifyModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化导航条上的内容
        setNav()
        
        // 初始化collView
        setCollectionView()
        
        // 加载分类数据
        collView.header.beginRefreshing()
    }
    
    fileprivate func setNav() {
        navigationItem.title = "分类"
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "search_1", highlImageName: "search_2", targer: self, action: #selector(ClassifyViewController.searchClick))
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func searchClick() {
        let searchVC = SearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    fileprivate func setCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let margin: CGFloat = 10
        layout.minimumInteritemSpacing = margin
        layout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin)
        let itemH:CGFloat = 80
        var itemW = (AppWidth - 4 * margin) / 3 - 2
        if AppWidth > 375 {
            itemW -= 3
        }
        layout.itemSize = CGSize(width: itemW, height: itemH)
        layout.headerReferenceSize = CGSize(width: AppWidth, height: 50)
        
        collView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collView.backgroundColor = theme.SDBackgroundColor
        collView.delegate = self
        collView.dataSource = self
        collView.alwaysBounceVertical = true
        collView.register(CityHeadCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headView")
        collView.register(UINib(nibName: "ClassifyCell", bundle: nil), forCellWithReuseIdentifier: "classifyCell")
        collView.showsHorizontalScrollIndicator = false
        collView.showsVerticalScrollIndicator = false
        collView.contentInset = UIEdgeInsetsMake(0, 0, NavigationH + 49, 0)
        view.addSubview(collView)
        
        let diyHeader = SDRefreshHeader(refreshingTarget: self, refreshingAction: #selector(ClassifyViewController.loadDatas))
        diyHeader?.lastUpdatedTimeLabel!.isHidden = true
        diyHeader?.stateLabel!.isHidden = true
        // HONG compile error!
        //diyHeader?.gifView!.frame = CGRect(x: (AppWidth - SD_RefreshImage_Width) * 0.5, y: 10, width: SD_RefreshImage_Width, height: SD_RefreshImage_Height)
        collView.header = diyHeader
    }
    
    func loadDatas() {
        weak var tmpSelf = self
        let time = DispatchTime.now() + Double(Int64(0.8 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) { () -> Void in
            
            ClassifyModel.loadClassifyModel { (data, error) -> () in
                if error != nil {
                    SVProgressHUD.showError(withStatus: "网络不给力")
                    tmpSelf!.collView.header.endRefreshing()
                    return
                }
                tmpSelf!.classData = data!
                tmpSelf!.collView.header.endRefreshing()
                tmpSelf!.collView.reloadData()
            }
        }
    }
}


// MARK - UICollectionViewDelegate UICollectionViewDataSource 代理方法
extension ClassifyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.classData?.list?[section].tags?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return self.classData?.list?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "classifyCell", for: indexPath) as! ClassifyCell
        cell.model = classData!.list![indexPath.section].tags![indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headView", for: indexPath) as! CityHeadCollectionReusableView
        
        headView.headTitle = self.classData?.list?[indexPath.section].title
        return headView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let every: EveryClassModel = classData!.list![indexPath.section].tags![indexPath.row]
        let detailVC = ClassDetailViewController()
        detailVC.title = every.name
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
}
