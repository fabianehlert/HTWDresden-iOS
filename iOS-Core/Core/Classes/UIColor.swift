//
//  UIColor.swift
//  Pods
//
//  Created by Benjamin Herzog on 25.02.16.
//
//

import UIKit

extension UIColor {
    
    convenience init(r: Int, g: Int, b: Int, a: Double = 1) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b), alpha: CGFloat(a))
    }
}
