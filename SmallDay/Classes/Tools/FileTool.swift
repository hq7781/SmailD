//
//  FileTool.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/9/1.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  管理沙盒文件的工具

import UIKit

class FileTool: NSObject {
    
    static let fileManager = FileManager.default
    
    /// 计算单个文件的大小
    class func fileSize(_ path: String) -> Double {
        
        if fileManager.fileExists(atPath: path) {
            var dict = try? fileManager.attributesOfItem(atPath: path)
            if let fileSize = dict![FileAttributeKey.size] as? Int{
                return Double(fileSize) / 1024.0 / 1024.0
            }
        }

        return 0.0
    }
    
    /// 计算整个文件夹的大小
    class func folderSize(_ path: String) -> Double {
        var folderSize: Double = 0
        if fileManager.fileExists(atPath: path) {
            let chilerFiles = fileManager.subpaths(atPath: path)
            for fileName in chilerFiles! {
                let tmpPath = path as NSString
                let fileFullPathName = tmpPath.appendingPathComponent(fileName)
                folderSize += FileTool.fileSize(fileFullPathName)
            }
            return folderSize
        }
        return 0
    }
    
    /// 彻底清除文件夹,异步
    class func cleanFolder(_ path: String, complete:@escaping () -> ()) {
        SVProgressHUD.show(withStatus: "正在清理缓存", maskType: SVProgressHUDMaskType.clear)
        let queue = DispatchQueue(label: "cleanQueue", attributes: [])
        
        queue.async { () -> Void in
            let chilerFiles = self.fileManager.subpaths(atPath: path)
            for fileName in chilerFiles! {
                let tmpPath = path as NSString
                let fileFullPathName = tmpPath.appendingPathComponent(fileName)
                if self.fileManager.fileExists(atPath: fileFullPathName) {
                    do {
                        try self.fileManager.removeItem(atPath: fileFullPathName)
                    } catch _ {
                    }
                }
            }
            
            // 线程睡1秒 测试,实际用到是将下面代码删除即可
            Thread.sleep(forTimeInterval: 1.0)
            
            DispatchQueue.main.async(execute: { () -> Void in
                SVProgressHUD.dismiss()
                complete()
            })
        }
    }
    
}
