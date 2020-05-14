//
//  NCBServicePaymentPresenter.swift
//  NCBApp
//
//  Created by Thuan on 6/7/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import ObjectMapper

protocol NCBServicePaymentPresenterDelegate {
    func getBillInfoPayooCompleted(billInfo: NCBBillInfoPayooModel?, error: String?)
    func getBillInfoVNPAYCompleted(billInfo: NCBBillInfoVNPAYModel?, error: String?)
    func getBillInfoNapasCompleted(billInfo: NCBBillInfoNapasModel?, error: String?)
}

class NCBServicePaymentPresenter {
    
    var delegate: NCBServicePaymentPresenterDelegate?
    var forCheckBill = false
    
    func getBillInfoPayoo(params: [String: Any]) {
        let apiService = NCBApiServicePaymentService()
        apiService.getBillInfoPayoo(params: params, success: { [unowned self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            
            if self.forCheckBill && (resObj.code == ResponseCodeConstant.success || resObj.code == ResponseCodeConstant.billPaid) {
                self.delegate?.getBillInfoPayooCompleted(billInfo: nil, error: nil)
                return
            }
            
            if resObj.code == ResponseCodeConstant.success {
                let billInfo = Mapper<NCBBillInfoPayooModel>().map(JSONString: resObj.body)
                self.delegate?.getBillInfoPayooCompleted(billInfo: billInfo, error: nil)
            } else {
                self.delegate?.getBillInfoPayooCompleted(billInfo: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getBillInfoPayooCompleted(billInfo: nil, error: error)
        }
    }
    
    func getBillInfoVNPAY(params: [String: Any]) {
        let apiService = NCBApiServicePaymentService()
        apiService.getBillInfoVNPAY(params: params, success: { [unowned self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            
            if self.forCheckBill && (resObj.code == ResponseCodeConstant.success || resObj.code == ResponseCodeConstant.billPaid) {
                self.delegate?.getBillInfoVNPAYCompleted(billInfo: nil, error: nil)
                return
            }
            
            if resObj.code == ResponseCodeConstant.success {
                let billInfo = Mapper<NCBBillInfoVNPAYModel>().map(JSONString: resObj.body)
                self.delegate?.getBillInfoVNPAYCompleted(billInfo: billInfo, error: nil)
            } else {
                self.delegate?.getBillInfoVNPAYCompleted(billInfo: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getBillInfoVNPAYCompleted(billInfo: nil, error: error)
        }
    }
    
    func getBillInfoNapas(params: [String: Any]) {
        let apiService = NCBApiServicePaymentService()
        apiService.getBillInfoNapas(params: params, success: { [unowned self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            
            if self.forCheckBill && (resObj.code == ResponseCodeConstant.success || resObj.code == ResponseCodeConstant.billPaid) {
                self.delegate?.getBillInfoNapasCompleted(billInfo: nil, error: nil)
                return
            }
            
            if resObj.code == ResponseCodeConstant.success {
                let billInfo = Mapper<NCBBillInfoNapasModel>().map(JSONString: resObj.body)
                self.delegate?.getBillInfoNapasCompleted(billInfo: billInfo, error: nil)
            } else {
                self.delegate?.getBillInfoNapasCompleted(billInfo: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getBillInfoNapasCompleted(billInfo: nil, error: error)
        }
    }
    
}
