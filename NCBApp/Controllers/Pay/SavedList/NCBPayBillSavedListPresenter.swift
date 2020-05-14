//
//  NCBPayBillSavedListPresenter.swift
//  NCBApp
//
//  Created by Thuan on 6/11/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import ObjectMapper

protocol NCBPayBillSavedListPresenterDelegate {
    func getSavedListCompleted(savedList: [NCBPayBillSavedModel]?, error: String?)
}

class NCBPayBillSavedListPresenter {
    
    var delegate: NCBPayBillSavedListPresenterDelegate?
    
    func getSavedList(params: [String: Any]) {
        let apiService = NCBApiServicePaymentService()
        apiService.getSavedList(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let savedList = Mapper<NCBPayBillSavedModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.getSavedListCompleted(savedList: savedList, error: nil)
            } else {
                self?.delegate?.getSavedListCompleted(savedList: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getSavedListCompleted(savedList: nil, error: error)
        }
    }
    
}
