//
//  NCBHomeMenuIconCollectionViewCell.swift
//  NCBApp
//
//  Created by Thuan on 4/2/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBHomeMenuIconCollectionViewCell: UICollectionViewCell {
    
    //MARK: Outlets
    
    @IBOutlet weak var wrapView: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var bgIconView: UIImageView!
    
    //MARK: Properties
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lbTitle.font = regularFont(size: 12)
        lbTitle.textColor = ColorName.blurNormalText.color
    }
    
    func setupMainData(_ item: NCBMenuIconModel) {
        lbTitle.text = item.title
        iconView.image = UIImage(named: item.image)?.withRenderingMode(.alwaysTemplate)
        iconView.tintColor = UIColor.white
        if item.type == IconType.accountInfo.rawValue || item.type == IconType.editFunction.rawValue {
            shake(false)
        } else {
            shake(true)
        }
    }
    
    func seupOtherData(_ item: NCBMenuIconModel) {
        lbTitle.text = item.title
        iconView.image = UIImage(named: item.image)?.withRenderingMode(.alwaysTemplate)
        if item.existsForMain {
            iconView.tintColor = UIColor(hexString: "6B6B6B")
        } else {
            iconView.tintColor = UIColor.white
        }
        bgIconView.isHidden = item.existsForMain
        wrapView.backgroundColor = UIColor.clear
    }
    
    func seupCardServiceData(_ item: NCBCardServiceMenuIconModel) {
        lbTitle.text = item.title
        iconView.image = UIImage(named: item.image)?.withRenderingMode(.alwaysTemplate)
        iconView.tintColor = UIColor.white
        wrapView.backgroundColor = UIColor.clear
    }
    
    func seupChargeMoneData(_ item: ChargeMoneyModel) {
        lbTitle.text = item.name
        iconView.image = UIImage(named: item.icon)?.withRenderingMode(.alwaysTemplate)
        iconView.tintColor = UIColor.white
        wrapView.backgroundColor = UIColor.clear
    }
    
    func shake(_ value: Bool) {
        if !value {
            wrapView.layer.removeAllAnimations()
        } else {
            let transformAnim  = CAKeyframeAnimation(keyPath:"transform")
            transformAnim.values  = [NSValue(caTransform3D: CATransform3DMakeRotation(0.04, 0.0, 0.0, 1.0)),NSValue(caTransform3D: CATransform3DMakeRotation(-0.04 , 0, 0, 1))]
            transformAnim.autoreverses = true
            transformAnim.duration  = 0.105
            transformAnim.repeatCount = Float.infinity
            wrapView.layer.add(transformAnim, forKey: "transform")
        }
    }

}
