//
//  UIImage+wnxImage.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/9/8.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//

import Foundation

// UIImage的扩展
extension UIImage {
    /// 按尺寸裁剪图片大小
    class func imageClipToNewImage(_ image: UIImage, newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        //image.draw(in: CGRect(origin: CGPointZero, size: newSize))
        image.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

    /// 将传入的图片裁剪成带边缘的原型图片
    class func imageWithClipImage(_ image: UIImage, borderWidth: CGFloat, borderColor: UIColor) -> UIImage {
        let imageWH = image.size.width
//        let border = borderWidth
        let ovalWH = imageWH + 2 * borderWidth
        
        //UIGraphicsBeginImageContextWithOptions(CGSizeMake(ovalWH, ovalWH), false, 0)
        UIGraphicsBeginImageContextWithOptions(CGSize(width:ovalWH, height:ovalWH), false, 0)
        //let path = UIBezierPath(ovalIn: CGRectMake(0, 0, ovalWH, ovalWH))
        let path = UIBezierPath(ovalIn: CGRect(x:0, y:0, width:ovalWH, height:ovalWH))
        borderColor.set()
        path.fill()
        
        //let clipPath = UIBezierPath(ovalIn: CGRectMake(borderWidth, borderWidth, imageWH, imageWH))
        let clipPath = UIBezierPath(ovalIn: CGRect(x:borderWidth, y:borderWidth, width:imageWH, height:imageWH))
        clipPath.addClip()
        //image.draw(at: CGPointMake(borderWidth, borderWidth))
        image.draw(at: CGPoint(x:borderWidth, y:borderWidth))
        
        let clipImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return clipImage!
    }
    
    /// 将传入的图片裁剪成圆形图片
    func imageClipOvalImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        let ctx = UIGraphicsGetCurrentContext()
        let rect = CGRectMake(x: 0, y: 0, width: self.size.width, height: self.size.height)
        ctx!.addEllipse(in: rect)
        
        ctx?.clip()
        self.draw(in: rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    func CGSizeMake( width: CGFloat,  height: CGFloat) -> CGSize{
        return CGSize(width: width, height: height)
    }
    func CGRectMake( x: CGFloat,  y: CGFloat, width:CGFloat, height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    func CGPointMake( x: CGFloat,  y: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: y)
    }
    func CGPointZero() -> CGPoint {
        return CGPoint(x: 0, y: 0)
    }
}
