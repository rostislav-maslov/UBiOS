//
//  PaidDeliveryBottomSheetView.swift
//  SushiVesla
//
//  Created by Vladislav Meleshko on 20/02/2019.
//  Copyright © 2019 UnitBean. All rights reserved.
//

import UIKit

class PaidDeliveryBottomSheetView: UIView {

    @IBOutlet weak var deliveryPriceLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var ownButton: UIButton!
    
    let height: CGFloat = 240.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    @IBAction func ownButtonDidTouch(_ sender: Any) {
        if let vc = self.superview?.parentOfChildeViewController as? BottomSheetViewController {
            WorkersBottomSheet.routToRestotants(vc)
        }
    }
    
    @IBAction func doneDidTouch(_ sender: Any) {
        if let vc = self.superview?.parentOfChildeViewController {
            vc.remove()
        }
    }
    
    private func setupView() {
        
        doneButton.layer.cornerRadius = 10.0
        
        ownButton.layer.cornerRadius = 10.0
        ownButton.layer.borderWidth = 1.0
        ownButton.layer.borderColor = UIColor.svCherryRedColor().cgColor
    }
    

}
