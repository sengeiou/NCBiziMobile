//
//  NCBVerifyTransferFooterView.swift
//  NCBApp
//
//  Created by Thuan on 4/17/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

typealias NCBVerifyTransferFooterViewVerifyOTP = () -> (Void)
typealias NCBVerifyTransferFooterViewUseBiometric = (BiometricIDAuth) -> (Void)

class NCBVerifyTransferFooterView: UIView {
    
    //MARK: Outlets
    
    @IBOutlet weak var verifyBtn: NCBCommonButton!
    @IBOutlet weak var biometricBtn: UIButton!
    @IBOutlet weak var lbBiometricDesc: UILabel!
    @IBOutlet weak var biometricContainerView: UIView!
    
    //MARK: Properties
    
    var verifyOTP: NCBVerifyTransferFooterViewVerifyOTP!
    var useBiometric: NCBVerifyTransferFooterViewUseBiometric!
    fileprivate let touchMe = BiometricIDAuth()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        biometricContainerView.isHidden = (touchMe.biometricType() == .none)
        chooseBiometric()
        
        verifyBtn.setTitle("XÁC THỰC OTP", for: .normal)
        lbBiometricDesc.font = regularFont(size: 12)
        
        biometricBtn.addTarget(self, action: #selector(biometricAction), for: .touchUpInside)
    }
    
    @objc func biometricAction() {
        useBiometric(touchMe)
    }
    
    @IBAction func verifyAction(_ sender: Any) {
        verifyOTP()
    }
    
    func chooseBiometric() {
        switch touchMe.biometricType() {
        case .faceID:
            biometricBtn.setImage(R.image.ic_faceid(),  for: .normal)
            lbBiometricDesc.text = "Xác thực giao dịch bằng nhận diện khuôn mặt"
        default:
            biometricBtn.setImage(R.image.ic_touchid(),  for: .normal)
            lbBiometricDesc.text = "Xác thực giao dịch bằng vân tay"
        }
    }
    
    func hiddenBiometric(_ hidden: Bool) {
        if hidden {
            biometricContainerView.isHidden = true
        }
    }
    
}
