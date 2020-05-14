//
//  NCBAutoPaymentDetailPresenter.swift
//  NCBApp
//
//  Created by Thuan on 6/13/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import ObjectMapper

protocol NCBAutoPaymentDetailPresenterDelegate {
    func getDetailCompleted(detail: NCBAutoPayBillDetailModel?, error: String?)
    func deleteCompleted(error: String?)
}

class NCBAutoPaymentDetailPresenter {
    
    var delegate: NCBAutoPaymentDetailPresenterDelegate?
    
    func getDetail(params: [String: Any]) {
        let apiService = NCBApiServicePaymentService()
        apiService.getAutoPayBillDetail(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let detail = Mapper<NCBAutoPayBillDetailModel>().map(JSONString: resObj.body)
                self?.delegate?.getDetailCompleted(detail: detail, error: nil)
            } else {
                self?.delegate?.getDetailCompleted(detail: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getDetailCompleted(detail: nil, error: error)
        }
    }
    
    func delete(params: [String: Any]) {
        let apiService = NCBApiServicePaymentService()
        apiService.deleteAutoPayBill(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                self?.delegate?.deleteCompleted(error: nil)
            } else {
                self?.delegate?.deleteCompleted(error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.deleteCompleted(error: error)
        }
    }
    
}
