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
        
        bottomDragViewConstraint.constant = -view.frame.height
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.bottomDragViewConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    @IBAction func dismissButtonDidTouch(_ sender: Any) {
        self.remove()
    }

    private func setupView() {
        view.layoutIfNeeded()
        panGuest = UIPanGestureRecognizer(target: self, action: #selector(draggView))
        dragView.addGestureRecognizer(panGuest)
        
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
        
        switch containerType {
        case .zoneNotAvailible:
            setupZoneNotAvailible()
        case .paidDelivery:
            setupPaidDelivery(costOfDelivery)
        }
        
        //view.layoutIfNeeded()
        
        debugPrint(dragView.frame, containerView.frame)
        
    }
    
    //MARK: - Cases
    
    private func setupZoneNotAvailible() {
        let zoneNotAvailibleView = (Bundle.main.loadNibNamed("ZoneNotAvailibleBottomSheetView", owner: nil, options: nil)?.first as! ZoneNotAvailibleBottomSheetView)
        heightDragViewConstraint.constant = zoneNotAvailibleView.height
        containerView.addSubview(zoneNotAvailibleView)
        
    }
    
    private func setupPaidDelivery(_ costOfDelivery: String) {
        let paidDeliveryView = (Bundle.main.loadNibNamed("PaidDeliveryBottomSheetView", owner: nil, options: nil)?.first as! PaidDeliveryBottomSheetView)
        paidDeliveryView.deliveryPriceLabel.text = costOfDelivery + "₽"
        heightDragViewConstraint.constant = paidDeliveryView.height
        containerView.addSubview(paidDeliveryView)
        
    }
    
    
    //MARK: - Helpers
    
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
                UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: .calculationModeCubic, animations: {
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.3, animations: {
                        if self.dragView.center.y > y + 50 {
                            panView.center.y = y + self.dragView.frame.height + 10
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
        }
    }
}
