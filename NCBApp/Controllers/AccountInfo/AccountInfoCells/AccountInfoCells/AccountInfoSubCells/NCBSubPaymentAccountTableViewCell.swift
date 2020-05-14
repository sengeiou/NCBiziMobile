//
//  NCBSubPaymentAccountTableViewCell.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/4/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit
import SwipeCellKit

typealias NCBSubPaymentAccountTableViewCellInternalTransfer = () -> (Void)
typealias NCBSubPaymentAccountTableViewCellInterbankTransfer = () -> (Void)
typealias NCBSubPaymentAccountTableViewCellStatement = () -> (Void)
typealias NCBSubPaymentAccountTableViewCellPayment = () -> (Void)

class NCBSubPaymentAccountTableViewCell: SwipeTableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var paymentAccountNameLbl: UILabel? {
        didSet {
            paymentAccountNameLbl!.font = semiboldFont(size: 14)
            paymentAccountNameLbl!.textColor = UIColor.init(hexString: "1A4C98")
            
        }
    }
    
    @IBOutlet weak var limitLbl: UILabel? {
        didSet {
            limitLbl!.font = regularFont(size: 12.0)
            limitLbl!.textColor = UIColor.init(hexString: "6B6B6B")
            
        }
    }
    
    @IBOutlet weak var paymentAccountSerieLbl: UILabel? {
        didSet {
            paymentAccountSerieLbl!.font = regularFont(size: 12.0)
            paymentAccountSerieLbl!.textColor = UIColor.init(hexString: "6B6B6B")
            
        }
    }
    
    @IBOutlet weak var paymentAccountSurplusLbl: NCBCurrencyLabel? {
        didSet {
            paymentAccountSurplusLbl!.font = UIFont.systemFont(ofSize: 12.0)
            paymentAccountSurplusLbl!.textColor = UIColor.init(hexString: "6B6B6B")
        }
    }
    
    @IBOutlet weak var paymentAccountDetailBtn: UIButton!
    @IBOutlet weak var seperatorView: UIView!
    
    // MARK: - Properties
    var amount: Double = 0.0 {
        didSet {
            paymentAccountSurplusLbl!.text = amount.currencyFormatted
        }
    }

    var dealHistoryOnSearch: NCBSearchHistoryDealItemModel? {
        didSet {
            setupData()
        }
    }
    var dealStatement: NCBDealStatementContentModel? {
        didSet {
            setupDealStatementData()
        }
    }
    
    var detailPaymentModel: NCBDetailPaymentAccountModel?
    var creditModel: NCBCreditCardModel?
    var internalTransfer: NCBSubPaymentAccountTableViewCellInternalTransfer!
    var interbankTransfer: NCBSubPaymentAccountTableViewCellInterbankTransfer!
    var statement: NCBSubPaymentAccountTableViewCellStatement!
    var payment: NCBSubPaymentAccountTableViewCellPayment!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        selectionStyle = .none
    }
    
    func setupData() {
        if let _dealHistoryOnSearch = dealHistoryOnSearch {
            paymentAccountNameLbl!.text = _dealHistoryOnSearch.transDateFormat
            paymentAccountSerieLbl!.text = _dealHistoryOnSearch.message
            amount = _dealHistoryOnSearch.getAmount() ?? 0.0
            if amount < 0 {
                paymentAccountSurplusLbl!.textColor = UIColor(hexString: ColorName.pinkishRed.rawValue)
            } else {
                paymentAccountSurplusLbl!.textColor = UIColor(hexString: ColorName.mediumBlue.rawValue)
            }
        }
    }
    func setupDealStatementData() {
        if let _dealStatement = dealStatement {
            paymentAccountNameLbl!.text = _dealStatement.ddtxn
            paymentAccountSerieLbl!.text = _dealStatement.txndateFormat
            amount = _dealStatement.getAmount() ?? 0.0
            if amount < 0 {
                paymentAccountSurplusLbl!.textColor = UIColor(hexString: ColorName.pinkishRed.rawValue)
            } else {
                paymentAccountSurplusLbl!.textColor = UIColor(hexString: ColorName.mediumBlue.rawValue)
            }
        }
    }

    func setDataForPaymentAccountSection(_ model: NCBDetailPaymentAccountModel) {
        paymentAccountNameLbl!.text = model.categoryName
        paymentAccountSerieLbl!.text = model.acctNo
        limitLbl!.text = ""
        amount = Double(model.curBal ?? 0)
        
        detailPaymentModel = model
        delegate = self
    }
    
    func setupDataCell(with data: NCBDetailHistoryDealItemModel?) {
        amount = data?.getAmount() ?? 0.0
        paymentAccountNameLbl!.text = data?.txndateFormat
        paymentAccountNameLbl?.textColor = UIColor(hexString:"7F7F7F")
        paymentAccountNameLbl?.font = UIFont.systemFont(ofSize: 10)
        
        paymentAccountSerieLbl!.text = data?.message
        limitLbl?.text = ""
        
        if amount < 0 {
            paymentAccountSurplusLbl!.textColor = UIColor(hexString: ColorName.pinkishRed.rawValue)
        } else {
            paymentAccountSurplusLbl!.textColor = UIColor(hexString: ColorName.mediumBlue.rawValue)
        }
    }
    
    func setupDataForDebtAccount(_ model: NCBDebtAccountModel, indexPath: IndexPath) {
        if indexPath.row == 0 {
            paymentAccountNameLbl!.text = "Thông tin khoản vay"
            limitLbl!.text = "Dư nợ"
        } else {
            paymentAccountNameLbl?.text = ""
            limitLbl?.text = ""
        }
        
        amount = model.amount ?? 0.0
        paymentAccountSerieLbl!.text = model.acctno
    }
    
    func setupDataForCreditCard(_ model: NCBCreditCardModel, indexPath: IndexPath) {
        if indexPath.row == 0 {
            paymentAccountNameLbl!.text = "Thẻ tín dụng"
            limitLbl!.text = "Hạn mức tín dụng"
        } else {
            paymentAccountNameLbl?.text = ""
            limitLbl?.text = ""
        }
        
        if model.isPrimaryCard {
            amount = model.creditLimit ?? 0.0
        } else {
            paymentAccountSurplusLbl?.text = "Thẻ phụ"
        }
        paymentAccountSerieLbl!.text = model.cardno?.cardHidden
        
        creditModel = model
        delegate = self
    }
    
    func setupDataForQRTransferHistory(_ model: NCBQRTransferHistoryItemModel) {
        paymentAccountNameLbl?.text = model.bookDate
        paymentAccountSerieLbl!.text = model.marchantName
        paymentAccountSurplusLbl!.text = model.amount
    }
}

extension NCBSubPaymentAccountTableViewCell: SwipeTableViewCellDelegate {

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        if let payment = detailPaymentModel, payment.categoryCode != StringConstant.salaryAccountCode && payment.categoryCode != StringConstant.overdraftAccountCode {
            let internalTransferAction = SwipeAction(style: .destructive, title: "Chuyển tiền\nnội bộ") { [weak self] action, indexPath in
                self?.internalTransfer()
            }
            internalTransferAction.backgroundColor = UIColor(hexString: "023892")
            internalTransferAction.image = R.image.ic_action_internal_transfer()
            internalTransferAction.font = regularFont(size: 12)
            
            let interbankTransferAction = SwipeAction(style: .destructive, title: "Chuyển tiền\nkhác NCB") { [weak self] action, indexPath in
                self?.interbankTransfer()
            }
            interbankTransferAction.image = R.image.ic_action_interbank_transfer()
            interbankTransferAction.backgroundColor = UIColor(hexString: "023892")
            interbankTransferAction.font = regularFont(size: 12)
            
            return [interbankTransferAction, internalTransferAction]
        }
        
        if let _ = creditModel {
            let internalTransferAction = SwipeAction(style: .destructive, title: "Sao kê\nthẻ tín dụng") { [weak self] action, indexPath in
                self?.statement()
            }
            internalTransferAction.backgroundColor = UIColor(hexString: "023892")
            internalTransferAction.image = R.image.ic_action_card_statement()
            internalTransferAction.font = regularFont(size: 12)
            
            let interbankTransferAction = SwipeAction(style: .destructive, title: "Thanh toán\nthẻ") { [weak self] action, indexPath in
                self?.payment()
            }
            interbankTransferAction.image = R.image.ic_action_card_payment()
            interbankTransferAction.backgroundColor = UIColor(hexString: "023892")
            interbankTransferAction.font = regularFont(size: 12)
            
            return [interbankTransferAction, internalTransferAction]
        }

        return  nil
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.buttonSpacing = 5
        return options
    }

}

