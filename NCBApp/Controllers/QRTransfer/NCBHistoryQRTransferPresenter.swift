//
//  NCBHistoryTransferPresenter.swift
//  NCBApp
//
//  Created by Lê Sơn on 6/12/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

protocol NCBHistoryQRTransferPresenterDelegate {
    func getListTransferHistoryCompleted(transferList: [NCBQRTransferHistoryItemModel]?, error: String?)
}

class NCBHistoryQRTransferPresenter {
    
    var delegate: NCBHistoryQRTransferPresenterDelegate?
    
    func getQRHistoryTransferList(params: [String : Any]) {
        let apiService = NCBQRTransferService()
        apiService.getListHistoryQRTransfer(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let items = Mapper<NCBQRTransferHistoryItemModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.getListTransferHistoryCompleted(transferList: items, error: nil)
            } else {
                self?.delegate?.getListTransferHistoryCompleted(transferList: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getListTransferHistoryCompleted(transferList: nil, error: error)
        }
    }
    
}
