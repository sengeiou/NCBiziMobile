//
//  NCBBeneficiariesCreatePresenter.swift
//  NCBApp
//
//  Created by Thuan on 6/14/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

protocol NCBBeneficiariesCreatePresenterDelegate {
    func createBeneficiaryCompleted(error: String?)
}

class NCBBeneficiariesCreatePresenter {
    
    var delegate: NCBBeneficiariesCreatePresenterDelegate?
    
    func create(params: [String: Any]) {
        let apiService = NCBApiBeneficiaryService()
        apiService.createBeneficiary(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                self?.delegate?.createBeneficiaryCompleted(error: nil)
            } else {
                self?.delegate?.createBeneficiaryCompleted(error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.createBeneficiaryCompleted(error: error)
        }
    }
    
}
