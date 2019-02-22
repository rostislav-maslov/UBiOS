//
//  UIViewControllerExtension.swift
//  SushiVesla
//
//  Created by Vladislav Meleshko on 20/02/2019.
//  Copyright © 2019 UnitBean. All rights reserved.
//

import Foundation

extension UIViewController {
    func add(_ child: UIViewController, frame: CGRect? = nil) {
        
        addChild(child)
        
        if let frame = frame {
            child.view.frame = frame
        }
        
        view.addSubview(child.view)
        
        //для правильного отображения на разных экранах
        if #available(iOS 11.0, *) {
            child.view.frame = view.bounds
        } else {
            child.view.frame = view.bounds
            child.view.frame.origin.y -= UIApplication.shared.statusBarFrame.height
        }
        child.view.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin]
        
        child.didMove(toParent: self)
    }
    
    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
