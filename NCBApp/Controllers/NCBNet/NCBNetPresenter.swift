//
//  NCBNetPresenter.swift
//  NCBApp
//
//  Created by Thuan on 8/7/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

protocol NCBNetPresenterDelegate {
    func getAllBranchCompleted(branchList: [NCBNetBranchModel]?, error: String?)
    func getATMCompleted(atmList: [NCBNetBranchModel]?, error: String?)
}

class NCBNetPresenter {
    
    var delegate: NCBNetPresenterDelegate?
    
    func getAllBranch() {
        let apiService = NCBExchangeRateService()
        apiService.getAllBranch(success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let branchList = Mapper<NCBNetBranchModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.getAllBranchCompleted(branchList: branchList, error: nil)
            } else {
                self?.delegate?.getAllBranchCompleted(branchList: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getAllBranchCompleted(branchList: nil, error: error)
        }
    }
    
    func getATM() {
        let apiService = NCBExchangeRateService()
        apiService.getATM(success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let branchList = Mapper<NCBNetBranchModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.getATMCompleted(atmList: branchList, error: nil)
            } else {
                self?.delegate?.getATMCompleted(atmList: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getATMCompleted(atmList: nil, error: error)
        }
    }
    
}
