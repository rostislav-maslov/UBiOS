//
//  BottomSheetViewController.swift
//  SushiVesla
//
//  Created by Vladislav Meleshko on 20/02/2019.
//  Copyright © 2019 UnitBean. All rights reserved.
//

import UIKit

class BottomSheetViewController: UIViewController {
    
    @IBOutlet weak var heightDragViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomDragViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dragView: UIView!
    @IBOutlet weak var bottomContainerConstraint: NSLayoutConstraint!
    
    //MARK: Cases
    var costOfDelivery: String = ""
    
    private var panGuest = UIPanGestureRecognizer()
    
    var containerType: ContainerType = .zoneNotAvailible
    
    enum ContainerType {
        case zoneNotAvailible
        case paidDelivery
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        //анимация появления вью снизу
        self.bottomDragViewConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    @IBAction func dismissButtonDidTouch(_ sender: Any) {
        self.remove()
    }
    
    private func setupView() {
        
        panGuest = UIPanGestureRecognizer(target: self, action: #selector(draggView))
        dragView.addGestureRecognizer(panGuest)
        
        customizeDragView()
        switchCases()
        
        //прячем вью вниз, чтобы отбразить появление снизу
        bottomDragViewConstraint.constant = -view.frame.height
    }
    
    private func customizeDragView() {
        if Device.IS_IPHONE_X || Device.IS_IPHONE_XS_MAX {
            bottomContainerConstraint.constant = 25
        } else {
            bottomContainerConstraint.constant = 8
        }
        
        let rectShape = CAShapeLayer()
        var bounds = dragView.bounds
        bounds.size.width = self.view.frame.width
        rectShape.bounds = dragView.frame
        rectShape.position = dragView.center
        rectShape.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topRight , .topLeft ], cornerRadii: CGSize(width: 8, height: 8)).cgPath
        dragView.layer.mask = rectShape
    }
    
    private func switchCases() {
        switch containerType {
        case .zoneNotAvailible:
            setupZoneNotAvailible()
        case .paidDelivery:
            setupPaidDelivery(costOfDelivery)
        }
    }
    
    //MARK: - Cases
    
    private func setupZoneNotAvailible() {
        let zoneNotAvailibleView = (Bundle.main.loadNibNamed("ZoneNotAvailibleBottomSheetView", owner: nil, options: nil)?.first as! ZoneNotAvailibleBottomSheetView)
        heightDragViewConstraint.constant = zoneNotAvailibleView.height
        zoneNotAvailibleView.frame.size.width = UIScreen.main.bounds.width
        containerView.addSubview(zoneNotAvailibleView)
        
    }
    
    private func setupPaidDelivery(_ costOfDelivery: String) {
        let paidDeliveryView = (Bundle.main.loadNibNamed("PaidDeliveryBottomSheetView", owner: nil, options: nil)?.first as! PaidDeliveryBottomSheetView)
        paidDeliveryView.deliveryPriceLabel.text = costOfDelivery + "₽"
        heightDragViewConstraint.constant = paidDeliveryView.height
        paidDeliveryView.frame.size.width = UIScreen.main.bounds.width
        containerView.addSubview(paidDeliveryView)
        
    }
    
    
    //MARK: - Helpers
    
    private func dragAnimation(_ panView: UIView) {
        //50 dismissible point
        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.3, animations: {
                if self.dragView.center.y > y + 50 {
                    panView.center.y = y + self.dragView.frame.height
                    self.view.backgroundColor = .clear
                } else {
                    panView.center.y = y
                }
            })
            
        }, completion: { _ in
            if self.dragView.center.y > y + 50 {
                self.remove()
            }
        })
    }
    
    @objc func draggView() {
        let translation = panGuest.translation(in: dragView)
        let y = self.view.frame.height - dragView.frame.height/2
        
        if let panView = panGuest.view {
            
            panView.center = CGPoint(x: panView.center.x, y: panView.center.y + translation.y)
            
            if translation.y < 0 {
                if panView.center.y < y {
                    panView.center.y = y
                } else {
                    panGuest.setTranslation(CGPoint(), in: dragView)
                }
            } else {
                panGuest.setTranslation(CGPoint(), in: dragView)
            }
            
            if panGuest.state == .ended {
                dragAnimation(panView)
            }
        }
    }
}
