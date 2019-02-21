//
//  ZoneNotAvailibleBottomSheetView.swift
//  SushiVesla
//
//  Created by Vladislav Meleshko on 20/02/2019.
//  Copyright © 2019 UnitBean. All rights reserved.
//

import UIKit

class ZoneNotAvailibleBottomSheetView: UIView {
    
    @IBOutlet weak var ownButton: UIButton!
    
    let height: CGFloat = 192.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    private func setupView() {
        
        ownButton.layer.cornerRadius = 10.0
        ownButton.layer.borderWidth = 1.0
        ownButton.layer.borderColor = UIColor.svCherryRedColor().cgColor
    }
    
    @IBAction func ownButtonDidTouch(_ sender: Any) {
        if let vc = self.superview?.parentOfChildeViewController as? BottomSheetViewController {
            WorkersBottomSheet.routToRestotants(vc)
        }
    }
    
    
}
