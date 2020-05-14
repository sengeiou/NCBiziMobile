//
//  NCBISavingsViewController.swift
//  NCBApp
//
//  Created by ADMIN on 8/21/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

enum SavingFormsType: Int {
    case ISavingSaving = 0
    case AccumulateSaving
}

enum ISavingBottomSheet: Int {
    case sendSchedule = 1
    case termInterest = 2
    case toMatureForm = 3
}

fileprivate let interestBeginingPeriod = "Đầu kỳ"

class NCBISavingsViewController: NCBBaseSourceAccountViewController {
 
    
    @IBOutlet weak var depositsView: NCBTransferAmountView!{
        didSet {
            depositsView.textField.placeholder = "Số tiền gửi"
        }
    }
    
    @IBOutlet weak var sendScheduleView: NCBTermDepView!{
        didSet {
            
           sendScheduleView.textField.placeholder = "Chọn kỳ hạn gửi"
        }
    }
    @IBOutlet weak var termInterestTf: NewNCBCommonTextField!{
        didSet {
            termInterestTf.addRightArrow(true)
            termInterestTf.placeholder = "Chọn kỳ lĩnh lãi"
            termInterestTf.delegate = self
        }
    }
    @IBOutlet weak var termInterestConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var toMatureFormTf: NewNCBCommonTextField!{
        didSet {
            toMatureFormTf.addRightArrow(true)
            toMatureFormTf.placeholder = "Hình thức đáo hạn"
            toMatureFormTf.delegate = self
        }
    }
    @IBOutlet weak var destinationAccountsTf: NewNCBCommonTextField!{
        didSet {
            destinationAccountsTf.addRightArrow(true)
            destinationAccountsTf.placeholder = "Tài khoản hưởng gốc, lãi"
            destinationAccountsTf.delegate = self
        }
    }
    @IBOutlet weak var continueBtn: NCBCommonButton!{
        didSet {
            continueBtn.setTitle("Tiếp tục", for: .normal)
            continueBtn.backgroundColor = UIColor(hexString: "D6DEE4")
        }
    }
    
   
    @IBAction func termDeposit(_ sender: UITapGestureRecognizer) {
      
        if let listTerm = savingAmountModel?.lstTerms {
            switch savingFormType {
            case .ISavingSaving:
                self.allTerms = listTerm.filter{ $0.value != "48M" }
                self.pushTermList = listTerm.filter{ $0.value != "48M"}.compactMap{ $0 }
            case .AccumulateSaving:
                self.allTerms = listTerm.filter{ $0.value == "3M" || $0.value == "6M" || $0.value == "12M" || $0.value == "24M" || $0.value == "36M" || $0.value == "48M" || $0.value == "60M" }
                self.pushTermList = listTerm.filter{ $0.value == "3M" || $0.value == "6M" || $0.value == "12M" || $0.value == "24M" || $0.value == "36M"  || $0.value == "48M" || $0.value == "60M" }.compactMap{ $0 }
            }
        }
       
        var bottomSheetItems = [BottomSheetStringItem]()
        for item in pushTermList {
            bottomSheetItems.append(BottomSheetStringItem(title: item.name ?? "", isCheck: sendScheduleView.textField.text == item.name))
        }
        if let vc = R.storyboard.bottomSheet.ncbBottomSheetListViewController() {
            vc.setData("Chọn kỳ hạn gửi", items: bottomSheetItems, isHasOptionItem: true)
            vc.delegate = self
            showBottomSheet(controller: vc, size: CGFloat(500))
            currentBottomSheet = ISavingBottomSheet.sendSchedule.rawValue
        }
    }
    
    //MARK: Properties
    
    fileprivate var items = [BottomSheetDetailStringItem]()
    fileprivate var strTitle = ""
    fileprivate var isHasOptionItem = false
    var p :NCBSavingAccumulationPresenter?
    
    var accountPresenter: NCBGeneralAccountPresenter?
    var allTerms: [NCBSendSavingItemModel] = []
    var iSavingTerms: [NCBSendSavingItemModel] = []
    var sendSavingItemModel: NCBSendSavingItemModel!
    
    
    
    var currentBottomSheet = ISavingBottomSheet.sendSchedule.rawValue
    
    var getInterestTerms: [NCBSendSavingItemModel] = []
    var interestTermModel:NCBSendSavingItemModel!
    
    var termList: [String] = []
    var periodTimes: [Int] = []
    var interestTerms: [String] = []
    var toMatureFormArr:[String] = []
    var savingFormType = SavingFormsType.AccumulateSaving
    var listRollTypes: [NCBSendSavingItemModel] = []
    var savingAmountModel: NCBSendSavingAmountModel?
    
    var pushTermList: [NCBSendSavingItemModel] = []
    lazy var termValue = ""
    lazy var interest = ""
    var isDestinationAccounts = false
    var newList:[NCBDetailPaymentAccountModel]!
    var accPaymentAccount = ""
    fileprivate var isFirstLoad = true
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        clearData()
        isFirstLoad = false
    }
    
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    
    @IBAction func contiue(_ sender: Any) {
        
        if let _sourceAccount = sourceAccount?.acctNo,
            let _sendAmount   = depositsView.textField.text,
            let _interest     = sendScheduleView?.getInterestRate(),
            let _fdend        = toMatureFormTf.text,
            let _benAcct      = destinationAccountsTf.text {
            
            if _sendAmount == "" {
                showAlert(msg: "OPENSAVING-1".getMessage() ?? "Vui lòng nhập số tiền")
                return
            }
            
            if Double(_sendAmount.removeSpecialCharacter) ?? 0.0 < 1000000.0 {
                showAlert(msg: "OPENSAVING-5".getMessage()?.replacingOccurrences(of: StringConstant.var1MsgNeedRepalce, with: "1,000,000") ?? "Số tiền tối thiểu mở tài khoản tiết kiệm là 1,000,000 VND. Quý khách vui lòng thử lại")
                return
            }
            if Double(_sendAmount.removeSpecialCharacter) ?? 0.0 > sourceAccount?.curBal ?? 0.0 {
                showAlert(msg: "Tài khoản nguồn không đủ số dư. Quý khách vui lòng kiểm tra lại")
                return
            }
            
            if termValue == "" {
                showAlert(msg: "OPENSAVING-2".getMessage() ?? "Vui lòng chọn kỳ hạn gửi")
                return
            }
            
            if termInterestTf.isHidden {
                if toMatureFormTf.text == "" {
                    showAlert(msg: "OPENSAVING-4".getMessage() ?? "Vui lòng chọn hình thức đáo hạn")
                    return
                }
            } else {
                if termInterestTf.text == ""{
                    showAlert(msg: "OPENSAVING-3".getMessage() ?? "Vui lòng chọn kỳ lĩnh lãi")
                    return
                }
                
                if toMatureFormTf.text == "" {
                    showAlert(msg: "Vui lòng chọn hình thức đáo hạn")
                    return
                }
            }
            
            let openSavingAccountDic: [String : Any] = [
                "cifno"     : NCBShareManager.shared.getUser()?.cif ?? "",
                "debitAcct" : _sourceAccount,
                "ccy"       : "VND",
                "amount"    :  _sendAmount.removeSpecialCharacter,
                "term"      :  termValue,
                "termStr"   :  allTerms.filter { $0.value == termValue }[0].name ?? "",
                "interest"  :  interest,
                "dest"      :  savingFormType == .ISavingSaving ? getInterestTerms.filter{ $0.name == termInterestTf.text }[0].value ?? "" : getInterestTerms[0].value ?? "",
                "fdend"     : listRollTypes.filter { $0.name == _fdend }[0].value ?? "",
                "benAcct"   : _benAcct,
                "username"  : NCBShareManager.shared.getUser()?.username ?? "",
                "typeId"    : savingFormType == .AccumulateSaving ? "GG" : (termInterestTf.text == "Đầu kỳ" ? "CD" : "FD")
            ]
            
            let openSavingAccountModel = Mapper<NCBOpenSavingAccountModel>().map(JSON: openSavingAccountDic)
            
            if let _vc = R.storyboard.sendSaving.ncbVerifySavingAccountViewController() {
                
                _vc.openSavingAccountModel = openSavingAccountModel
                _vc.savingFormType = self.savingFormType
                let listRollTypeFiltered = listRollTypes.filter{ $0.value == openSavingAccountModel?.fdend }
                let listTermFiltered = allTerms.filter { $0.value == openSavingAccountModel?.term }
                if listRollTypeFiltered.count > 0 && listTermFiltered.count > 0 {
                    if let _sendAmount = depositsView.textField.text,
                        let _term      = termInterestTf.text {
                        var dataArr: [TransactionModel] = []
                        dataArr.append(TransactionModel(title: "Tài khoản nguồn", value: openSavingAccountModel?.debitAcct ?? ""))
                        dataArr.append(TransactionModel(title: "Số tiền gửi", value: (Double(_sendAmount.removeSpecialCharacter) ?? 0.0).currencyFormatted))
                        dataArr.append(TransactionModel(title: "Kỳ hạn", value: listTermFiltered[0].name ?? ""))
                        if savingFormType == .ISavingSaving {
                            dataArr.append(TransactionModel(title: "Kỳ lĩnh lãi", value: getInterestTerms.filter{ $0.name == _term }[0].name ?? "" ))
                        } else {
                            dataArr.append(TransactionModel(title: "Kỳ lĩnh lãi", value: getInterestTerms[0].name ?? ""))
                        }
                        dataArr.append(TransactionModel(title: "Lãi suất", value: _interest))
                        dataArr.append(TransactionModel(title: "Hình thức đáo hạn", value: listRollTypeFiltered[0].name ?? ""))
                        dataArr.append(TransactionModel(title: "Tài khoản hưởng gốc, lãi", value: openSavingAccountModel?.benAcct ?? ""))
                        
                        _vc.setData(dataArr, type: .openSavingAccount)
                        self.navigationController?.pushViewController(_vc, animated: true)
                    }
                } else {
                    showAlert(msg: "Vui lòng nhập đầy đủ thông tin")
                }
            }
            
        } else {
            showAlert(msg: "Vui lòng nhập đầy đủ thông tin")
        }
    }
    
    override func loadDefaultSourceAccount() {
        let result = listPaymentAccount.sorted() {
            ($0.curBal ?? 0.0) > ($1.curBal ?? 0.0)
        }
        
        listPaymentAccount = result
        sourceAccount = result[0]
        sourceAccount?.isSelected = true
        sourceAccountView?.setSourceAccount(sourceAccount?.acctNo)
        sourceAccountView?.setSourceName(sourceAccount?.acName)
        sourceAccountView?.setSourceBalance(sourceAccount?.curBal)
        destinationAccountsTf.text = sourceAccount?.acctNo
        newList = copyListPaymentAccount(list: listPaymentAccount)
    }
  
    override func viewDidSelectSourceAccount(_ account: NCBDetailPaymentAccountModel) {
        destinationAccountsTf.text = account.acctNo
        self.sourceAccountView?.setSourceAccount(account.acctNo)
        self.sourceAccountView?.setSourceName(account.acName)
        self.sourceAccountView?.setSourceBalance(account.curBal)
        self.sourceAccount = account
        self.sourceAccount?.isSelected = true
        
        var item = newList.first(where: { $0.isSelected == true })
        item?.isSelected = false
        
        item = newList.first(where: { $0.acctNo == account.acctNo })
        item?.isSelected = true
        
        removeBottomSheet()
    }
    
}

extension NCBISavingsViewController {
    
    override func setupView() {
        super.setupView()
        
        switch savingFormType {
        case .AccumulateSaving:
             setCustomHeaderTitle("Gửi tiết kiệm tích lũy")
            termInterestConstraint.constant = 0
            termInterestTf.isHidden = true
            self.view.layoutSubviews()
        default:
            setCustomHeaderTitle("Tiết kiệm thường/Tiền gửi có kỳ hạn")
            termInterestConstraint.constant = 65
            termInterestTf.isHidden = false
            self.view.layoutSubviews()
        }
        p = NCBSavingAccumulationPresenter()
        p?.delegate = self
        p?.getSavingConfig()
       
    }
    
    override func loadLocalized() {
        super.loadLocalized()
 
    }
    
    func setData(_ title: String, items: [BottomSheetDetailStringItem], isHasOptionItem: Bool, isHasSearchView: Bool? = false) {
        self.strTitle = title
        self.items = items
        self.isHasOptionItem = isHasOptionItem
        
    }
    
    fileprivate func clearData() {
        if NCBShareManager.shared.areTrading || isFirstLoad {
            return
        }
        
        depositsView.clear()
        sendScheduleView.clear()
        termInterestTf.text = ""
        toMatureFormTf.text = ""
        defaultSourceAccount()
    }
    
    func getInterestDetail(with text: String) {
        var interestTermKey: String = ""
        var termCode: String = ""
        for interestTerm in getInterestTerms {
            if text == interestTerm.name {
                switch savingFormType {
                case .AccumulateSaving:
                    termCode = "ROLL_TYPE"
                default:
                    termCode = interestTerm.value ?? ""
                }
                let textSplited = interestTerm.value?.components(separatedBy: "-")
                if textSplited?.count ?? 0 > 0 {
                    interestTermKey = textSplited?[0] ?? ""
                }
            }
        }
        listRollTypes = savingAmountModel?.lstRollTypes ?? []
        toMatureFormArr = setupRollType(with: termCode)
        
        if let _paymentAccount = sourceAccount, let _acctNo = _paymentAccount.acctNo {
            let keyPI: String = "\(interestTermKey)-\(_acctNo)-\(termValue)"
            p?.getInterestRate(params: ["keyPI":"\(keyPI)"])
        }
    }
    
    func sortInterestTerms(){
//        var indx = 0
//        var i = 0
//        if interestTerms.count<2{
//            return
//        }
//        for item in interestTerms{
//            if item == "Cuối kỳ"{
//                indx = i
//                break
//            }
//            i = i+1
//        }
//        if indx == interestTerms.count-1{
//            return
//        }
//        interestTerms.swapAt(indx, interestTerms.count-1)
    }
    
    func copyListPaymentAccount(list:[NCBDetailPaymentAccountModel]) -> [NCBDetailPaymentAccountModel] {
        var newList :[NCBDetailPaymentAccountModel] = []
        for item in list {
            newList.append(item.copy() as! NCBDetailPaymentAccountModel)
        }
        return newList
    }
}

extension NCBISavingsViewController:UITextFieldDelegate
{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == termInterestTf{
            if sendScheduleView.textField.text == ""{
                showAlert(msg: "Xin vui lòng chọn kỳ hạn gửi trước")
                 return false
            }
            var bottomSheetItems = [BottomSheetStringItem]()
            sortInterestTerms()
            for item in self.interestTerms {
                bottomSheetItems.append(BottomSheetStringItem(title: item, isCheck: termInterestTf.text == item))
            }
            if let vc = R.storyboard.bottomSheet.ncbBottomSheetListViewController() {
                vc.setData("Chọn kỳ lĩnh lãi", items: bottomSheetItems, isHasOptionItem: true)
                vc.delegate = self
                var height = CGFloat(56*self.interestTerms.count+200)
                if height > self.view.frame.height - 100 {
                    height = self.view.frame.height - 100
                }
                showBottomSheet(controller: vc, size: height)
                currentBottomSheet = ISavingBottomSheet.termInterest.rawValue
            }
            
            return false
        }
        
        if textField == toMatureFormTf{
            if !termInterestTf.isHidden && termInterestTf.text == ""{
                showAlert(msg: "Vui lòng chọn kỳ lĩnh lãi trước")
                return false
            }
            
            if sendScheduleView.textField.text == ""{
                showAlert(msg: "Xin vui lòng chọn kỳ hạn gửi trước")
                return false
            }
            
             currentBottomSheet = ISavingBottomSheet.toMatureForm.rawValue
            var bottomSheetItems = [BottomSheetStringItem]()
            for item in self.toMatureFormArr {
                bottomSheetItems.append(BottomSheetStringItem(title: item, isCheck: toMatureFormTf.text == item))
            }
            if let vc = R.storyboard.bottomSheet.ncbBottomSheetListViewController() {
                vc.setData("Chọn hình thức đáo hạn", items: bottomSheetItems, isHasOptionItem: true)
                vc.delegate = self
                var height = CGFloat(56*toMatureFormArr.count+200)
                if height > self.view.frame.height - 100 {
                    height = self.view.frame.height - 100
                }
                showBottomSheet(controller: vc, size: height)
                currentBottomSheet = ISavingBottomSheet.toMatureForm.rawValue
            }
            
            return false
        }
        if textField == destinationAccountsTf{
            if termInterestTf.text?.lowercased() == interestBeginingPeriod.lowercased() {
                return false
            }
            if let controller = R.storyboard.cardService.ncbListAccountRegistrationATMViewController() {
                showBottomSheet(controller: controller, size: 350)
                controller.delegate = self
                controller.setupData(newList)
                controller.setTitle(str: "Chọn tài khoản hưởng gốc, lãi")
            }
           return false
        }
        
        return true
}

}

extension NCBISavingsViewController: NCBSavingAccumulationPresenterDelegate
{
    func getInterestRateCompleted(rate: String?, error: String?) {
        if let error = error {
            showAlert(msg: error)
        }
        
        if let _rate = rate {
            sendScheduleView.setInterestRate("Lãi suất: \(_rate)%")
            interest = _rate
        }
    }
    
    func getSavingConfigCompleted(savingAccount: NCBSendSavingAmountModel?, error: String?) {
        if let error = error {
            showAlert(msg: error)
        }
        if let savingAccount = savingAccount {
            
            self.savingAmountModel = savingAccount
            
            switch savingFormType {
            case .ISavingSaving:
                if var listTerm = savingAccount.lstTerms {
                    self.periodTimes = setupTermList(array: &listTerm).1
                    self.termList = setupTermList(array: &listTerm).0
                }
                self.allTerms = savingAccount.lstTerms ?? []
                self.getInterestTerms = savingAccount.lstInterestTerm ?? []
            case .AccumulateSaving:
                self.getInterestTerms = savingAccount.lstAccumulateInterestTerm ?? []
            }
            
            
            self.listRollTypes = savingAccount.lstRollTypes ?? []
        }
    }
    
    func setupISavingTerms(){
        
        for item in allTerms {
            let value =  Int(item.type ?? "0")
            print(SendSavingFromValue.iSaving.rawValue)
            if  value == SendSavingFromValue.iSaving.rawValue{
                iSavingTerms.append(item)
            }
        }
    }
    
    func setupTermList( array: inout [NCBSendSavingItemModel]) -> ([String],[Int]) {
        termList = []
        periodTimes = []
        for item in array {
            termList.append(item.name ?? "")
        }
        for item in array {
            if let name = item.value {
                if !name.contains("D"){
                    if let _periodTime = Int(name.replacingOccurrences(of: "M", with: "")) {
                        periodTimes.append(_periodTime)
                    }
                }
            }
        }
        return (termList, periodTimes)
    }
    
    
    func setupInterestTerm(with term: Int) -> [String] {
        
        interestTerms = []
        switch savingFormType {
        case .ISavingSaving:
            interestTerms.append(getInterestTerms[0].name ?? "")
            switch term {
            case 24... where term % 12 == 0:
                interestTerms.append(getInterestTerms[1].name ?? "")
                interestTerms.append(getInterestTerms[2].name ?? "")
                interestTerms.append(getInterestTerms[3].name ?? "")
                interestTerms.append(getInterestTerms[4].name ?? "")
            case 12... where term % 6 == 0:
                interestTerms.append(getInterestTerms[1].name ?? "")
                interestTerms.append(getInterestTerms[2].name ?? "")
                interestTerms.append(getInterestTerms[3].name ?? "")
                if term > 12 && term % 12 == 0{
                    interestTerms.append(getInterestTerms[4].name ?? "")
                }
            case 6... where term % 3 == 0:
                interestTerms.append(getInterestTerms[1].name ?? "")
                interestTerms.append(getInterestTerms[2].name ?? "")
                
                if term > 6 && term % 6 == 0 {
                    interestTerms.append(getInterestTerms[3].name ?? "")
                }
            case 2...:
                interestTerms.append(getInterestTerms[1].name ?? "")
            default:
                break
            }
            interestTerms.append(getInterestTerms[5].name ?? "")
            
            return interestTerms
        case .AccumulateSaving:
            return [getInterestTerms[0].name ?? ""]
        }
    }
    
    func setupRollType(with termValue: String) -> [String] {
        
        return self.listRollTypes.filter({ $0.code == termValue }).compactMap({ $0.name })
    }
    
}
extension NCBISavingsViewController: NCBBottomSheetListViewControllerDelegate
{
    func bottomSheetListDidSelectItem(_ item: String, index: Int) {
        removeBottomSheet()
        
        switch currentBottomSheet {
        case ISavingBottomSheet.sendSchedule.rawValue:
            sendSavingItemModel = pushTermList[index]
            sendScheduleView.textField.text = sendSavingItemModel.name
            for term in self.allTerms {
                if sendSavingItemModel.name == term.name {
                    if let _termValue = term.value {
                        self.termValue = _termValue
                    }
                    if (!(term.value?.contains("D"))!) {
                        if let _periodTime = Int(term.value!.replacingOccurrences(of: "M", with: "")) {
                            self.interestTerms = self.setupInterestTerm(with: _periodTime)
                        }
                    } else {
                        self.interestTerms = [self.getInterestTerms[5].name ?? ""]
                    }
                }
            }
            switch self.savingFormType {
            case .AccumulateSaving:
                self.getInterestDetail(with: self.getInterestTerms[0].name ?? "")
            default:
                break
            }
            
            termInterestTf.text = ""
            toMatureFormTf.text = ""
            sendScheduleView.clearInterestRate()
            
        case ISavingBottomSheet.termInterest.rawValue:
            if item.lowercased() == interestBeginingPeriod.lowercased() {
                destinationAccountsTf.text = sourceAccount?.acctNo
                
                var item = newList.first(where: { $0.isSelected == true })
                item?.isSelected = false
                
                item = newList.first(where: { $0.acctNo == sourceAccount?.acctNo })
                item?.isSelected = true
            }
            getInterestDetail(with: item)
            termInterestTf.text = item
            toMatureFormTf.text = ""
        case ISavingBottomSheet.toMatureForm.rawValue:
            toMatureFormTf.text = item
        default:
            break
        }
    }
}

extension NCBISavingsViewController: NCBListAccountRegistrationATMViewControllerDelegate {
    func didSelectPaymentAccount(_ account: NCBDetailPaymentAccountModel) {
        self.destinationAccountsTf.text = account.acctNo
        account.isSelected = true
        removeBottomSheet()
    }
}
