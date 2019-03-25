//
//  UIImageExtencion.swift
//  Lab1
//
//  Created by student on 3/20/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

extension UIImage {
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        } else {
            return self
        }
    }
}

extension UIView {
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }
        
        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }
        
        return nil
    }
    
    func getCoordRelative(toView view: UIView) -> CGPoint? {
        
        var result = CGPoint(x: 0, y: 0)
        var currView: UIView? = self
        
        guard view != self else {
            return result
        }
        
        while currView != view && currView != nil {
            if let superView = currView?.superview {
                result.x += currView!.frame.minX
                result.y += currView!.frame.minY
                currView = superView
            }
            else {
                currView = nil
            }
        }
        
        return currView != nil ? result : nil
    }
}
