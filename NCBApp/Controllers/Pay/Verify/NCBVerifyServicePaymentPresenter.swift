//
//  NCBVerifyServicePaymentPresenter.swift
//  NCBApp
//
//  Created by Thuan on 6/10/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

@objc protocol NCBVerifyServicePaymentPresenterDelegate {
    @objc optional func createOTPCodeCompleted(msgId: String?, error: String?)
    @objc optional func saveServiceCompleted(error: String?)
}

class NCBVerifyServicePaymentPresenter {
    
    var delegate: NCBVerifyServicePaymentPresenterDelegate?
    
    func createOTPCode(params: [String: Any], type: PayBillOTPType) {
        let apiService = NCBApiServicePaymentService()
        apiService.createOTPCode(params: params, type: type, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                self?.delegate?.createOTPCodeCompleted?(msgId: resObj.body, error: nil)
            } else {
                self?.delegate?.createOTPCodeCompleted?(msgId: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.createOTPCodeCompleted?(msgId: nil, error: error)
        }
    }
    
    func saveService(providerCode: String, serviceCode: String, customerCode: String, memName: String, isActive: Bool) {
        var params: [String: Any] = [:]
        params["providerCode"] = providerCode
        params["serviceCode"] = serviceCode
        if isActive {
            params["status"] = PayBillingStatus.ACTIVE.rawValue
        } else {
            params["status"] = PayBillingStatus.CLOSE.rawValue
        }
        params["type"] = "BILLPAYMENT"
        params["memName"] = memName
        params["cifno"] = NCBShareManager.shared.getUser()!.cif
        params["billNo"] = customerCode
        
        let apiService = NCBApiServicePaymentService()
        apiService.saveService(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                self?.delegate?.saveServiceCompleted?(error: nil)
            } else {
                self?.delegate?.saveServiceCompleted?(error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.saveServiceCompleted?(error: error)
        }
    }
    
}
