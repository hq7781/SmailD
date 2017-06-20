//
//  ThemeCell.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/8/22.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  探店美辑的cell

import UIKit

class ThemeCell: UITableViewCell {
    
    var model: ThemeModel? {
        didSet {
            titleLable.text = model!.title
            subTitleLable.text = model!.keywords
            backImageView.wxn_setImageWithURL(URL(string: model!.img!)! as NSURL, placeholderImage: UIImage(named: "quesheng")!)
        }
    }
    
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var subTitleLable: UILabel!
    @IBOutlet weak var backImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        self.titleLable.shadowOffset = CGSize(width: -1, height: 1)
        self.titleLable.shadowColor = UIColor.colorWith(20, green: 20, blue: 20, alpha: 0.1)
        self.subTitleLable.shadowOffset = CGSize(width: -1, height: 1)
        self.subTitleLable.shadowColor = UIColor.colorWith(20, green: 20, blue: 20, alpha: 0.1)
    }
    
    class func themeCellWithTableView(_ tableView: UITableView) -> ThemeCell {
        let identifier = "themeCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ThemeCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("ThemeCell", owner: nil, options: nil)?.last as? ThemeCell
            
        }
        
        return cell!
    }
}
