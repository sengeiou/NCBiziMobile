//
//  NCBBeneficiariesUpdatePresenter.swift
//  NCBApp
//
//  Created by Thuan on 6/14/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

protocol NCBBeneficiariesUpdatePresenterDelegate {
    func updateBeneficiaryCompleted(error: String?)
    func deleteBeneficiaryCompleted(error: String?)
}

class NCBBeneficiariesUpdatePresenter {
    
    var delegate: NCBBeneficiariesUpdatePresenterDelegate?
    
    func update(params: [String: Any]) {
        let apiService = NCBApiBeneficiaryService()
        apiService.updateBeneficiary(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                self?.delegate?.updateBeneficiaryCompleted(error: nil)
            } else {
                self?.delegate?.updateBeneficiaryCompleted(error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.updateBeneficiaryCompleted(error: error)
        }
    }
    
    func delete(params: [String: Any]) {
        let apiService = NCBApiBeneficiaryService()
        apiService.deleteBeneficiary(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                self?.delegate?.deleteBeneficiaryCompleted(error: nil)
            } else {
                self?.delegate?.deleteBeneficiaryCompleted(error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.deleteBeneficiaryCompleted(error: error)
        }
    }
    
}
