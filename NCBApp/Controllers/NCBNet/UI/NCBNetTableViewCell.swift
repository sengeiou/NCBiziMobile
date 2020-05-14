//
//  NCBNetTableViewCell.swift
//  NCBApp
//
//  Created by Thuan on 8/7/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit
import CoreLocation

class NCBNetTableViewCell: NCBBaseTableViewCell {
    
    //MARK: Outlets
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbTel: UILabel!
    @IBOutlet weak var lbDistance: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lbName.font = semiboldFont(size: 14)
        lbName.textColor = ColorName.blackText.color
        
        lbAddress.font = regularFont(size: 12)
        lbAddress.textColor = ColorName.blurNormalText.color
        
        lbTel.font = regularFont(size: 12)
        lbTel.textColor = UIColor(hexString: "7F7F7F")
        
        lbDistance.font = regularFont(size: 12)
        lbDistance.textColor = UIColor(hexString: "7F7F7F")
    }
    
    func setData(_ item: NCBNetBranchModel, lat: Double, lon: Double) {
//        if let name = item.name {
//            lbName.text = name
//        } else {
//            lbName.text = item.departName
//        }
        lbName.text = item.getDisplayName
        lbAddress.text = item.address
        
        var tel = ""
        if let phone = item.phone {
            tel = "Tel: \(phone)"
        }
        if let fax = item.fax {
            tel = tel + "   Fax: \(fax)"
        }
        lbTel.text = tel
        lbDistance.text = ""
        
        if let fromLat = item.latitude, let fromLon = item.longitude {
            let coordinate0 = CLLocation(latitude: Double(fromLat) ?? 0.0, longitude: Double(fromLon) ?? 0.0)
            let coordinate1 = CLLocation(latitude: lat, longitude: lon)
            
            let distanceInMeters = coordinate0.distance(from: coordinate1)
            lbDistance.text = "\((distanceInMeters/1000).round(to: 1))km"
        }
    }
    
}
