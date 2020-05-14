//
//  NCBApiOTPRequest.swift
//  NCBApp
//
//  Created by Thuan on 5/23/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import Moya

enum NCBApiOTPRequest {
    case approvalTransferInfo(params: [String: Any], type: TransactionType)
    case resendOTP(params: [String: Any], type: TransactionType)
    case getTransferLimit(params: [String: Any])
    case checkBalance(params: [String: Any], type: BalanceTransferType)
    case refreshToken(params: [String: Any])
}

extension NCBApiOTPRequest: NCBTargetType {
    
    var contentType: String {
        switch self {
        case .approvalTransferInfo(_, let type):
            switch type {
            case .finalSettlementSavingAccount, .payBillingPayoo:
                return contentTypeJson
            default:
                return contentTypeUrlencoded
            }
        case .resendOTP(_ , let type):
            switch type {
            case .userRequest:
                return contentTypeJson
            default:
                return contentTypeUrlencoded
            }
        default:
            return contentTypeUrlencoded
        }
    }
    
    var headers: [String : String]? {
        var headers: [String: String] = [:]
        switch self {
        case .refreshToken(_):
            headers["Authorization"] = basicAuthorization
        default:
            headers["Authorization"] = authorization
        }
        headers["Content-Type"] = contentType
        
        return headers
    }

    
    var path: String {
        switch self {
        case .approvalTransferInfo(_, let type):
            switch type {
            case .internalTransfer:
                return "/fund-transfer-service/transfer/approval-internal-transfer"
            case .citad:
                return "/fund-transfer-service/transfer/approval-citad-transfer"
            case .charity:
                return "/fund-transfer-service/transfer/approval-charity-transfer"
            case .finalSettlementSavingAccount:
                return "/saving-service/saving/closureSavingOnline"
            case .fast247:
                return "/payment-service/transfer/approval-247-transfer"
            case .payBillingPayoo:
                return "/payment-service/paybill/payBillingPAYOO"
            case .payBillingVNPAY:
                return "/payment-service/paybill/payBillingVNPAY"
            case .payBillingNapas:
                return "/payment-service/paybill/payBillingNAPAS"
            case .topupPhoneNumb:
                return "/payment-service/topup/confirmTopup"
            case .topupAirPay:
                return "/payment-service/topup/confirmTopupWallet"
            case .autoPaymentRegister:
                return "/payment-service/paybill/registerAutoPayBill"
            case .updateCardStatusUnlockApproval:
                return "/card-service/card/update-card-status-unlock-approval"
            case .cardActiveApproval:
                return "/card-service/card/card-active-approval"
            case .createAtmApproval:
                return "/card-service/card/create-atm-approval"
            case .reopenAtmApproval:
                return "/card-service/card/reopen-card-approval"
            case .reissuePinApproval:
                return "/card-service/card/reissue-pin-approval"
            case .creditCardPayment:
                return "/card-service/card/payment-card-approval"
            case .registerEcom:
                return "/card-service/card/register-ecomm-approval"
            case .openAccountOnline:
                return "/common-info-service/register/openAccountOnline"
            case .autoDebtDeduction:
                return "/card-service/card/card-auto-debit-approval"
            case .registerSMSBanking:
                return "/common-info-service/register/registerSMSBanking"
            case .additionalSavingAccount:
                return "saving-service/saving/topupAccountSaving"
            case .reopenVisaApproval:
                return "/card-service/card/reopen-visa-approval"
            case .softOTPRegister:
                return "/common-info-service/register/approve-soft-otp"
            case .softOTPResend:
                return "/common-info-service/register/approve-active-code-soft-otp"
            default:
                return ""
            }
        case .resendOTP(_, let type):
            switch type {
            case .internalTransfer, .citad, .fast247, .charity:
                return "/fund-transfer-service/transfer/regen-otp-transfer"
            case .creditCardPayment:
                return "/card-service/card/regen-otp-payment"
            case .registerEcom:
                return "/card-service/card/regen-otp-register-ecomm"
            case .updateCardStatusUnlockApproval:
                return "/card-service/card/regen-otp-card-unlock"
            case .cardActiveApproval:
                return "/card-service/card/regen-otp-card-active"
            case .autoDebtDeduction:
                return "/card-service/card/regen-otp-auto-debit"
            case .createAtmApproval:
                return "/card-service/card/regen-otp-create-atm"
            case .reopenAtmApproval:
                return "/card-service/card/regen-otp-reopen-atm"
            case .reopenVisaApproval:
                return "/card-service/card/regen-otp-reopen-visa"
            case .reissuePinApproval:
                return "/card-service/card/regen-otp-reissue-pin"
            case .userRequest:
                return "/api/v1/info/usr/regenerateotp"
            default:
                return "/fund-transfer-service/transfer/regen-otp"
            }
        case .getTransferLimit(_):
            return "/product-service/transfer-limit"
        case .checkBalance(_, let type):
            switch type {
            case .transfer:
                return "/fund-transfer-service/transfer/check-balance-transfer"
            case .card:
                return "/card-service/card/check-balance-card"
            case .rechargeMoney:
                return "/common-info-service/account/checkBalance"
            }
        case .refreshToken(_):
            return "/oauth/token"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .approvalTransferInfo(_, _):
            return .post
        case .resendOTP(_, _):
            return .post
        case .getTransferLimit(_):
            return .get
        case .checkBalance(_, _):
            return .post
        case .refreshToken(_):
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .approvalTransferInfo(let params, let type):
            switch type {
            case .finalSettlementSavingAccount, .payBillingPayoo:
                return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            default:
                return .requestParameters(parameters: params, encoding: URLEncoding.default)
            }
        case .resendOTP(let params, let type):
            switch type {
            case .userRequest:
                return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            default:
                return .requestParameters(parameters: params, encoding: URLEncoding.default)
            }
        case .getTransferLimit(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .checkBalance(let params, _):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .refreshToken(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
}
