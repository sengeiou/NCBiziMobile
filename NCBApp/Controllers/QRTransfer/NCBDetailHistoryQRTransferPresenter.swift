//
//  NCBDetailHistoryQRTransferPresenter.swift
//  NCBApp
//
//  Created by Lê Sơn on 6/12/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

protocol NCBDetailHistoryQRTransferPresenterDelegate {
    func getDetailTransferHistoryCompleted(transferInfo: NCBQRTransferHistoryDetailModel?, error: String?)
}

class NCBDetailHistoryQRTransferPresenter {
    
    var delegate: NCBDetailHistoryQRTransferPresenterDelegate?
    
    func getQRHistoryTransferList(params: [String : Any]) {
        let apiService = NCBQRTransferService()
        apiService.getDetailQRTransfer(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let item = Mapper<NCBQRTransferHistoryDetailModel>().map(JSONString: resObj.body)
                self?.delegate?.getDetailTransferHistoryCompleted(transferInfo: item, error: nil)
            } else {
                self?.delegate?.getDetailTransferHistoryCompleted(transferInfo: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getDetailTransferHistoryCompleted(transferInfo: nil, error: error)
        }
    }
    
}
