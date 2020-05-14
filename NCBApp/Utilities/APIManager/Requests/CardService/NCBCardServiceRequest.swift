//
//  File.swift
//  NCBApp
//
//  Created by ADMIN on 7/23/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import Foundation
import Moya

enum NCBCardServiceRequest {
    case getCrCardList(params: [String : Any])
    case updateCardStatusLock(params: [String : Any])
    case updateCardStatusUnlockConfirm(params: [String : Any])
    case updateCardStatusUnlockApproval(params: [String : Any])
    case cardActiveConfirm(params: [String : Any])
    case cardActiveApproval(params: [String : Any])
    case getCardListAutoDebtDeductionConfirm(params: [String : Any])
    case getCardListAutoDebtDeductionApproval(params: [String : Any])
    case getListBranch(params: [String : Any])
    case getListCardProduct(params: [String : Any])
    case getListCardClass(params: [String : Any])
    case getFeeCard(params: [String : Any])
    
    case getListAcctReopenAtm(params: [String : Any])
    case getFeeAcctReopenAtm(params: [String : Any])
    case getReasonAcctReopenAtm(params: [String : Any])
    case reopenAtmConfirm(params: [String : Any])
    case reopenAtmApproval(params: [String : Any])
 
    case createAtmConfirm(params: [String : Any])
    case createAtmApproval(params: [String : Any])
    case getListAccNo(params: [String : Any])
    
    case getListCardProductVisa(params: [String : Any])
    case createCardVisa(params: [String : Any])
    
    case getFeePin(params: [String : Any])
    case reissuePinConfirm(params: [String : Any])
    case reissuePinApproval(params: [String : Any])
    case checkCreateVisa(params: [String : Any])
    case checkReopenCard(params: [String : Any])
    
    case reopenVisaConfirm(params: [String : Any])
    case reopenVisaApproval(params: [String : Any])
    case checkReissuePin(params: [String : Any])


}

extension NCBCardServiceRequest: NCBTargetType {
    
    var path: String {
        switch self {
        case .getCrCardList(_):
            return "/card-service/card/get-CrCardList"
        case .updateCardStatusLock(_):
              return "/card-service/card/update-card-status-lock"
        case .updateCardStatusUnlockConfirm(_):
            return "card-service/card/update-card-status-unlock-confirm"
        case .updateCardStatusUnlockApproval(_):
            return "/card-service/card/update-card-status-unlock-approval"
        case .cardActiveConfirm(_):
            return "/card-service/card/card-active-confirm"
        case .cardActiveApproval(_):
            return "/card-service/card/card-active-approval"
        case .getCardListAutoDebtDeductionConfirm(_):
            return "card-service/card/card-auto-debit-confirm"
        case .getCardListAutoDebtDeductionApproval(_):
            return "card-service/card/card-auto-debit-approval"
        case .getListBranch(_):
            return "/product-service/get-list-branch"
        case .getListCardProduct(_):
            return "/card-service/card/get-list-card-product"
        case .getListCardClass(_):
            return "/card-service/card/get-list-card-class"
        case .getFeeCard(_):
            return "/card-service/card/get-fee-card"
            
        case .getListAcctReopenAtm(_):
            return "/card-service/card/get-list-acct-reopen-atm"
        case .getFeeAcctReopenAtm(_):
            return "/card-service/card/get-fee-acct-reopen-atm"
        case .getReasonAcctReopenAtm(_):
            return "/card-service/card/get-reason-acct-reopen-atm"
        case .reopenAtmConfirm(_):
            return "/card-service/card/reopen-card-confirm"
        case .reopenAtmApproval(_):
            return "/card-service/card/reopen-card-approval"
        case .reopenVisaConfirm(_):
            return "/card-service/card/reopen-visa-confirm"
        case .reopenVisaApproval(_):
            return "/card-service/card/reopen-visa-approval"
    
        case .createAtmConfirm(_):
            return "/card-service/card/create-atm-confirm"
        case .createAtmApproval(_):
            return "/card-service/card/create-atm-approval"
        case .getListAccNo(_):
            return "/card-service/card/getList-accNo"
        case .getListCardProductVisa(_):
            return "/card-service/card/get-list-card-product-visa"
        case .createCardVisa(_):
            return "/card-service/card/create-card-visa"
            
        case .getFeePin(_):
            return "/card-service/card/get-fee-pin"
        case .reissuePinConfirm(_):
            return "/card-service/card/reissue-pin-confirm"
            
        case .reissuePinApproval(_):
            return "/card-service/card/reissue-pin-approval"
        case .checkCreateVisa(_):
            return "/card-service/card/check-create-visa"
        case .checkReopenCard(_):
            return "/card-service/card/check-reopen-card"
        case .checkReissuePin(_):
            return "/card-service/card/check-reissue-pin"
        }
        
        
    }
        

    var method: Moya.Method {
        switch self {
        case .getCrCardList(_):
            return .get
        case .updateCardStatusLock(_):
            return .post
        case .updateCardStatusUnlockConfirm(_):
            return .post
        case .updateCardStatusUnlockApproval(_):
            return .post
        case .cardActiveConfirm(_):
            return .post
        case .cardActiveApproval(_):
            return .post
        case .getCardListAutoDebtDeductionConfirm(_):
            return .post
        case .getCardListAutoDebtDeductionApproval(_):
            return .post
        case .getListBranch(_):
            return .post
        case .getListCardProduct(_):
            return .post
        case .getListCardClass(_):
            return .post
        case .getFeeCard(_):
            return .post
        case .getListAcctReopenAtm(_):
            return .post
        case .getFeeAcctReopenAtm(_):
            return .post
        case .getReasonAcctReopenAtm(_):
            return .post
        case .reopenAtmConfirm(_):
            return .post
        case .reopenAtmApproval(_):
            return .post
        case .reopenVisaConfirm(_):
            return .post
        case .reopenVisaApproval(_):
            return .post
        case .createAtmConfirm(_):
            return .post
        case .createAtmApproval(_):
            return .post
        case .getListAccNo(_):
             return .post
        case .getListCardProductVisa(_):
            return .post
        case .createCardVisa(_):
            return .post
            
        case .getFeePin(_):
            return .post
        case .reissuePinConfirm(_):
            return .post
        case .reissuePinApproval(_):
            return .post
        case .checkCreateVisa(_):
            return .post
        case .checkReopenCard(_):
            return .post
        case .checkReissuePin(_):
            return .get
        }
        
    }
    
    var task: Task {
        switch self {
        case .getCrCardList(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .updateCardStatusLock(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .updateCardStatusUnlockConfirm(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .updateCardStatusUnlockApproval(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .cardActiveConfirm(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .cardActiveApproval(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getCardListAutoDebtDeductionConfirm(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getCardListAutoDebtDeductionApproval(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getListBranch(let params):
             return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getListCardProduct(let params):
             return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getListCardClass(let params):
             return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getFeeCard(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getListAcctReopenAtm(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getFeeAcctReopenAtm(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getReasonAcctReopenAtm(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .reopenAtmConfirm(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .reopenAtmApproval(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .createAtmConfirm(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .createAtmApproval(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getListAccNo(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getListCardProductVisa(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .createCardVisa(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .getFeePin(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .reissuePinConfirm(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .reissuePinApproval(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .checkCreateVisa(let params):
             return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .checkReopenCard(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .reopenVisaConfirm(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .reopenVisaApproval(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .checkReissuePin(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
}
