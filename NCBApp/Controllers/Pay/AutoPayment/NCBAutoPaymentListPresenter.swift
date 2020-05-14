//
//  NCBAutoPaymentListPresenter.swift
//  NCBApp
//
//  Created by Thuan on 6/13/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import ObjectMapper

protocol NCBAutoPaymentListPresenterDelegate {
    func getAutoPayBillListCompleted(autoPayBillList: [NCBPayBillSavedModel]?, error: String?)
}

class NCBAutoPaymentListPresenter {
    
    var delegate: NCBAutoPaymentListPresenterDelegate?
    
    func getAutoPayBillList(params: [String: Any]) {
        let apiService = NCBApiServicePaymentService()
        apiService.getAutoPayBillList(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let savedList = Mapper<NCBPayBillSavedModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.getAutoPayBillListCompleted(autoPayBillList: savedList, error: nil)
            } else {
                self?.delegate?.getAutoPayBillListCompleted(autoPayBillList: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getAutoPayBillListCompleted(autoPayBillList: nil, error: error)
        }
    }
    
}
