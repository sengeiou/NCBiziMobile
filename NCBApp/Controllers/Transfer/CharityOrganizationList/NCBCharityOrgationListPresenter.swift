//
//  NCBCharityOrgationListPresenter.swift
//  NCBApp
//
//  Created by Lê Sơn on 5/24/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

protocol NCBCharityOrgationListPresenterDelegate {
    func loadCharityFundListCompleted(charityFundList: [NCBCharityOrganizationModel]?, error: String?)
}

class NCBCharityOrgationListPresenter {
    
    var delegate: NCBCharityOrgationListPresenterDelegate?
    
    func getCharityFundList(params: [String : Any]) {
        let apiService = NCBCharityService()
        apiService.getCharityFundList(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let items = Mapper<NCBCharityOrganizationModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.loadCharityFundListCompleted(charityFundList: items, error: nil)
            } else {
                self?.delegate?.loadCharityFundListCompleted(charityFundList: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.loadCharityFundListCompleted(charityFundList: nil, error: error)
        }
    }
    
}
