//
//  UIViewExtension.swift
//  SushiVesla
//
//  Created by Levan Chikvaidze on 05.12.2018.
//  Copyright © 2018 UnitBean. All rights reserved.
//

import Foundation


extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        mask.backgroundColor = UIColor.black.cgColor
        layer.mask = mask
    }
}

extension UIView {
    var parentOfChildeViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
