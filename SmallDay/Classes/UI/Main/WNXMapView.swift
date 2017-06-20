//
//  WNXMapView.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/9/13.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  附近控制器地图View

import UIKit

private let customIdentifier = "pointReuseIndentifier"

class WNXMapView: MAMapView {
    var flags: [MAPointAnnotation] = [MAPointAnnotation]()
    var lastMAAnnotationView: MAAnnotationView?
    weak var pushVC: NearViewController?
    
    var nearsModel: DetailModel? {
        didSet {
            flags.removeAll(keepingCapacity: true)
            nearCollectionView.reloadData()
            for i in 0..<nearsModel!.list!.count {
                let eventModel = nearsModel!.list![i]
                if let position = eventModel.position?.stringToCLLocationCoordinate2D(",") {
                    let po = MAPointAnnotation()
                    po.coordinate = position
                    flags.append(po)
                    addAnnotation(po)
                    
                    if i == 0 {
                        selectAnnotation(po, animated: true)
                    }
                }
            }
        }
    }
    
    fileprivate lazy var nearCollectionView: UICollectionView = {
        let nearH: CGFloat = 105
        let layout = UICollectionViewFlowLayout()
        let margin: CGFloat = 20
        let itemW = AppWidth - 35 - 10
        
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: itemW, height: nearH)
        
        let nearCV = UICollectionView(frame: CGRect(x: 15, y: AppHeight - nearH - 10 - NavigationH, width: AppWidth - 35, height: nearH), collectionViewLayout: layout)
        nearCV.delegate = self
        nearCV.dataSource = self
        nearCV.clipsToBounds = false
        nearCV.register(UINib(nibName: "nearCell", bundle: nil), forCellWithReuseIdentifier: "nearCell")
        nearCV.isPagingEnabled = true
        nearCV.showsVerticalScrollIndicator = false
        nearCV.backgroundColor = UIColor.clear
        return nearCV
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        delegate = self
        showsCompass = false
        showsScale = false
        isShowsUserLocation = true
        logoCenter.x = AppWidth - logoSize.width + 20
        zoomLevel = 12
        setCenter(CLLocationCoordinate2D(latitude: 22.5633480000, longitude: 114.0795910000), animated: true)
        mapType = MAMapType.standard
        addSubview(myLocalBtn)
        addSubview(nearCollectionView)
    }
    
    fileprivate lazy var myLocalBtn: UIButton = {
        let btnWH: CGFloat = 57
        let btn = UIButton(frame: CGRect(x: 20, y: AppHeight - 180 - btnWH, width: btnWH, height: btnWH)) as UIButton
        btn.setBackgroundImage(UIImage(named: "dingwei_1"), for: UIControlState())
        btn.setBackgroundImage(UIImage(named: "dingwei_2"), for: .highlighted)
        btn.addTarget(self, action: #selector(WNXMapView.backCurrentLocal), for: .touchUpInside)
        return btn
        }()
    
    func backCurrentLocal() {
        setCenter(userLocation.coordinate, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
        clearDisk()
        print("地图view被销毁", terminator: "")
        isShowsUserLocation = false
    }
}

extension WNXMapView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nearsModel?.list?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nearCell", for: indexPath) as! nearCell
        let model = nearsModel!.list![indexPath.row]
        cell.nearModel = model
        cell.titleLabel.text = "\(indexPath.row + 1)." + cell.titleLabel.text!
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndext = Int(nearCollectionView.contentOffset.x / nearCollectionView.width + 0.5)
        let po = flags[currentIndext]
        selectAnnotation(po, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let eventVC = EventViewController()
        eventVC.model = nearsModel!.list![indexPath.item]
        pushVC?.navigationController?.pushViewController(eventVC, animated: true)
    }
}

extension WNXMapView: MAMapViewDelegate {
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKind(of: MAPointAnnotation.self) {
            var annot = mapView.dequeueReusableAnnotationView(withIdentifier: customIdentifier) as? MAPinAnnotationView
            if annot == nil {
                annot = MAPinAnnotationView(annotation: annotation, reuseIdentifier: customIdentifier) as MAPinAnnotationView
            }
            
            annot!.image = UIImage(named: "zuobiao1")
            annot!.center = CGPoint(x: 0, y: -(annot!.image.size.height * 0.5))
            return annot!
        }
        
        return nil
    }
    
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        lastMAAnnotationView?.image = UIImage(named: "zuobiao1")
        view.image = UIImage(named: "zuobiao2")
        lastMAAnnotationView = view
        setCenter(view.annotation.coordinate, animated: true)
        
        let currentIndex = CGFloat(annotationViewForIndex(view))
        nearCollectionView.setContentOffset(CGPoint(x: currentIndex * nearCollectionView.width, y: 0), animated: true)
    }
    
    fileprivate func annotationViewForIndex(_ annot: MAAnnotationView) -> Int {
        
        for i in 0..<flags.count {
            let po = flags[i]
            if view(for: po) === annot {
                return i
            }
        }
        
        return 0
    }
    
}


