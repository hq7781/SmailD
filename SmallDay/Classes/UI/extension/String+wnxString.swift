//
//  String+wnxString.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/9/8.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//

import Foundation
// String扩展
extension String {
    /// 判断是否是邮箱
    func validateEmail() -> Bool {
        let emailRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }
    
    /// 判断是否是手机号
    func validateMobile() -> Bool {
        let phoneRegex: String = "^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0,0-9]))\\d{8}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self)
    }
    
    /// 将字符串转换成经纬度
    func stringToCLLocationCoordinate2D(_ separator: String) -> CLLocationCoordinate2D? {
        //let arr = self.componentsSeparated(by: separator)
        let arr = self.components(separatedBy: separator)
        if arr.count != 2 {
            return nil
        }
        
        let latitude: Double = NSString(string: arr[1]).doubleValue
        let longitude: Double = NSString(string: arr[0]).doubleValue
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

extension NSMutableString {
    
    class func changeHeigthAndWidthWithSrting(_ searchStr: NSMutableString) -> NSMutableString {
        do {
            var mut = [CGFloat]()
            var mutH = [CGFloat]()
            let imageW = AppWidth - 23
            
            let rxHeight = try NSRegularExpression(pattern: "(?<= height=\")\\d*")
            let rxWidth = try NSRegularExpression(pattern: "(?<=width=\")\\d*")
            let widthArray = rxWidth.matches(searchStr as String) as! [String]
            
            for width  in widthArray {
                Int(width)!
                mut.append(imageW/CGFloat(Int(width)!))
            }
            
            var widthMatches = rxWidth.matches(in: searchStr as String, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, searchStr.length))
            
            /* for var i = widthMatches.count - 1; i >= 0; i -= 1 {
             let widthMatch = widthMatches[i] as NSTextCheckingResult
             searchStr.replaceCharacters(in: widthMatch.range, with: "\(imageW)")
             }*/
            for i  in 0 ..< (widthMatches.count - 1)
            {
                let widthMatch = widthMatches[widthMatches.count - 1 - i] as NSTextCheckingResult
                searchStr.replaceCharacters(in: widthMatch.range, with: "\(imageW)")
            }
            
            let newString = searchStr.mutableCopy() as! NSMutableString
            
            let heightArray = rxHeight.matches(newString as String) as! [String]
            for i in 0..<mut.count {
                mutH.append(mut[i] * CGFloat(Int(heightArray[i])!))
            }
            
            var matches = rxHeight.matches(in: newString as String, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, newString.length))
            /*
             for var i = matches.count - 1; i >= 0; i -= 1
             {
             let match = matches[i] as NSTextCheckingResult
             newString.replaceCharacters(in: match.range, with: "\(mutH[i])")
             } */
            for i  in 0 ..< (matches.count - 1)
            {
                let match = matches[matches.count - 1 - i] as NSTextCheckingResult
                newString.replaceCharacters(in: match.range, with: "\(mutH[matches.count - 1 - i])")
            }
            
            return newString
        } catch {
            print("error: changeHeigthAndWidthWithSrting")
        }
        return "";
    }
}
