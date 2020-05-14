//
//  NCBRegisterForLoanPresenter.swift
//  NCBApp
//
//  Created by Thuan on 8/27/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

protocol NCBRegisterForLoanPresenterDelegate {
    func getPurposesCompleted(purposes: [NCBLoanPurposeModel]?, payForms: [NCBLoanPayFormModel]?, error: String?)
    func registerLoanCompleted(error: String?)
}

class NCBRegisterForLoanPresenter {
    
    var delegate: NCBRegisterForLoanPresenterDelegate?
    
    func getPurposes() {
        let service = NCBRegisterServiceNewService()
        service.getPurposes(success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let dict = resObj.body.convertToDictionary()
                let lstPurpose = dict?["lstPurpose"]
                let purposes = Mapper<NCBLoanPurposeModel>().mapArray(JSONObject: lstPurpose)
                let lstReturnType = dict?["lstReturnType"]
                let payForms = Mapper<NCBLoanPayFormModel>().mapArray(JSONObject: lstReturnType)
                self?.delegate?.getPurposesCompleted(purposes: purposes, payForms: payForms, error: nil)
            } else {
                self?.delegate?.getPurposesCompleted(purposes: nil, payForms: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getPurposesCompleted(purposes: nil, payForms: nil, error: error)
        }
    }
    
    func registerLoan(params: [String : Any]) {
        let service = NCBRegisterServiceNewService()
        service.registerLoan(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                self?.delegate?.registerLoanCompleted(error: nil)
            } else {
                self?.delegate?.registerLoanCompleted(error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.registerLoanCompleted(error: error)
        }
    }
    
}
