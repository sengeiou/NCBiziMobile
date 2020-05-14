//
//  NCBReceiverListPresenter.swift
//  NCBApp
//
//  Created by Lê Sơn on 6/3/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

protocol NCBReceiverListPresenterDelegate {
    func loadBeneficiaryListCompleted(beneficiaryList: [NCBBeneficiaryModel]?, error: String?)
}

class NCBReceiverListPresenter {
    
    var delegate: NCBReceiverListPresenterDelegate?
    
    func getBeneficiaryList(params: [String : Any]) {
        let apiService = NCBApiBeneficiaryService()
        apiService.getBeneficiaryList(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let items = Mapper<NCBBeneficiaryModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.loadBeneficiaryListCompleted(beneficiaryList: items, error: nil)
            } else {
                self?.delegate?.loadBeneficiaryListCompleted(beneficiaryList: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.loadBeneficiaryListCompleted(beneficiaryList: nil, error: error)
        }
    }
    
}
