//
//  SearchViewController.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/8/18.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  搜索控制器

import UIKit

public let searchViewH: CGFloat = 50

class SearchViewController: UIViewController, SearchViewDelegate {
    
    fileprivate var searchView: SearchView!
    
    var searchModel: SearchsModel?
    
    fileprivate var scrollView: UIScrollView!
    
    fileprivate var hotSearchs: [String] = ["北京", "东四", "南锣鼓巷", "798", "三里屯", "维尼的小熊"]
    
    fileprivate var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: searchViewH, width: AppWidth, height: AppHeight - searchViewH), style: .plain)
        tableView.separatorStyle = .none
        tableView.rowHeight = 230
        tableView.isHidden = true
        tableView.contentInset = UIEdgeInsetsMake(0, 0, NavigationH, 0)
        tableView.register(UINib(nibName: "DetailCell", bundle: nil), forCellReuseIdentifier: SD_DetailCell_Identifier)
        return tableView
        }()
    
    fileprivate lazy var hotBtns: NSMutableArray = NSMutableArray()
    
    fileprivate lazy var hotLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 200, height: 50))
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "热门搜索"
        return label
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "搜索"
        view.backgroundColor = theme.SDBackgroundColor
        NotificationCenter.default.addObserver(self, selector: #selector(SearchViewController.keyBoardWillshow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        // 添加顶部的searchView
        setSearchView()
        
        setScrollView()
        
        setTableView()
    }
    
    fileprivate func setScrollView() {
        scrollView = UIScrollView(frame: CGRect(x: 0, y: searchViewH, width: AppWidth, height: AppHeight - searchViewH))
        scrollView.backgroundColor = theme.SDBackgroundColor
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .onDrag
        let tap = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.hideKeyboard))
        scrollView.addGestureRecognizer(tap)
        view.addSubview(scrollView)
        
        if hotSearchs.count > 0 {
            scrollView.addSubview(hotLabel)
            let margin: CGFloat = 10
            let btnH: CGFloat = 32
//            var btnX: CGFloat = 0
            var btnY: CGFloat = hotLabel.frame.maxY
            var btnW: CGFloat = 0
            let textMargin: CGFloat = 35
            for i in 0..<hotSearchs.count {
                let btn = UIButton()
                btn.setTitle(hotSearchs[i], for: UIControlState())
                btn.setTitleColor(UIColor.black, for: UIControlState())
                btn.titleLabel!.sizeToFit()
                btn.setBackgroundImage(UIImage(named: "populartags"), for: UIControlState())
                btnW = btn.titleLabel!.width + textMargin
                btn.addTarget(self, action: #selector(SearchViewController.searchBtnClick(_:)), for: .touchUpInside)
                if hotBtns.count > 0 {
                    let lastBtn = hotBtns.lastObject as! UIButton
                    let freeW = AppWidth - lastBtn.frame.maxX
                    if freeW > btnW + 2 * margin {
                        btn.frame = CGRect(x: lastBtn.frame.maxX + margin, y: btnY, width: btnW, height: btnH)
                    } else {
                        btnY = lastBtn.frame.maxY + margin
                        btn.frame = CGRect(x: margin, y: btnY, width: btnW, height: btnH)
                    }
                    hotBtns.add(btn)
                    scrollView.addSubview(btn)
                } else {
                    btn.frame = CGRect(x: margin, y: btnY, width: btnW, height: btnH)
                    hotBtns.add(btn)
                    scrollView.addSubview(btn)
                }
            }
        }
    }
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    func setSearchView() {
        searchView = SearchView(frame: CGRect(x: 0, y: 0, width: view.width, height: searchViewH))
        searchView.backgroundColor = UIColor.colorWith(247, green: 247, blue: 247, alpha: 1)
        searchView.delegate = self
        view.addSubview(searchView)
    }
    
    func searchBtnClick(_ sender: UIButton) {
        let text: String = sender.titleLabel!.text!
        searchDetail(text)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func searchDetail(_ title: String) {
        searchView.searchTextField.text = title
        searchModel = nil
        searchView.searchTextField.resignFirstResponder()
        
        weak var tmpSelf = self
        SearchsModel.loadSearchsModel(title, completion: { (data, error) -> () in
            if error != nil {//添加搜索失败view
                return
            }
            
            tmpSelf!.searchModel = data!
            tmpSelf!.tableView.isHidden = false
            tmpSelf!.scrollView.isHidden = true
            tmpSelf!.tableView.reloadData()
            tmpSelf!.searchView.searchBtn.isSelected = true
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchView.searchTextField.becomeFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("搜索控制器被销毁", terminator: "")
    }
    
    func keyBoardWillshow() {
        scrollView.isHidden = false
        tableView.isHidden = true
        self.searchModel = nil
        tableView.reloadData()
    }
    
    func searchView(_ searchView: SearchView, searchTitle: String) {
        searchDetail(searchTitle)
    }
    
    func hideKeyboard() {
        searchView.searchTextField.resignFirstResponder()
        searchView.resumeSearchTextField()
    }
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchModel?.list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SD_DetailCell_Identifier) as! DetailCell
        let everyModel = searchModel!.list![indexPath.row]
        cell.model = everyModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventModel = searchModel!.list![indexPath.row]
        let searchDetailVC = EventViewController()
        searchDetailVC.model = eventModel
        navigationController!.pushViewController(searchDetailVC, animated: true)
    }
}




