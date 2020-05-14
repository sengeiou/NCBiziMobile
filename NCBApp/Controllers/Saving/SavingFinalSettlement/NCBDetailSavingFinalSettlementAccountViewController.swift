//
//  NCBDetailSavingFinalSettlementAccountViewController.swift
//  NCBApp
//
//  Created by Van Dong on 27/08/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

struct DetailFinalSettlementInfo {
    var title1: String?
    var value1: String?
    var title2: String?
    var value2: String?
    
    init(title1: String?, value1: String?, title2: String?, value2: String?) {
        self.title1 = title1
        self.value1 = value1
        self.title2 = title2
        self.value2 = value2
    }
}

class NCBDetailSavingFinalSettlementAccountViewController: NCBBaseTransactionViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sourceAccountView: UIView!
    @IBOutlet weak var infoTableView: UIView!{
        didSet{
            infoTableView.layer.cornerRadius = 19
            infoTableView.clipsToBounds = true
            infoTableView.layer.masksToBounds = false
            infoTableView.layer.shadowColor = UIColor.black.cgColor
            infoTableView.layer.shadowOpacity = 0.13
            infoTableView.layer.shadowOffset = CGSize(width: 0, height: 0)
            infoTableView.layer.shadowRadius = 10
        }
    }
    @IBOutlet weak var btContinue: UIButton!{
        didSet{
            btContinue.setTitle("Tiếp tục", for: .normal)
        }
    }
    
    fileprivate var sourceAccountInfoView: NCBSourceAccountView?
    var detailFinalSettlementSavingAccount: NCBDetailSettlementSavingAccountModel?
    var listDetailInfo: [DetailFinalSettlementInfo] = []
    var p: NCBSavingAccountPresenter?
    var acctNo: String?
    var savingNo: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getSourceAccountPaymentList()
    }
    
    @IBAction func clickContinue(_ sender: Any) {
        guard let detailFinalSettlementSavingAccount = detailFinalSettlementSavingAccount else {
            return
        }
        
        if detailFinalSettlementSavingAccount.closureConfirm == true {
            showConfirm(msg: "Tài khoản tiết kiệm \(detailFinalSettlementSavingAccount.acctNo ?? "") đến hạn ngày \(detailFinalSettlementSavingAccount.matDate ?? ""). Nếu tất toán hôm nay, lãi ước tính được tính theo lãi suất không kỳ hạn.\nQuý khách có muốn tiếp tục thực hiện?") {
                self.showVerifyScreen()
            }
        } else {
            showVerifyScreen()
        }
    }
    
    fileprivate func showVerifyScreen() {
        if let vc = R.storyboard.saving.ncbTransferInfoSFSViewController(){
            vc.transferInfomation = TransferInfomationModel(amount:  self.detailFinalSettlementSavingAccount?.getCalAmt(), interest: "", sourceAccount: self.sourceAccountInfoView?.lbSourceAccountValue.text, balSourceAcount: self.sourceAccountInfoView?.lbBalance.text, savingAccount: self.detailFinalSettlementSavingAccount?.acctNo, termDest: self.detailFinalSettlementSavingAccount?.matDate)
            vc.accountSFS = self.detailFinalSettlementSavingAccount
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
extension NCBDetailSavingFinalSettlementAccountViewController{
    override func setupView() {
        super.setupView()
        sourceAccountInfoView = R.nib.ncbSourceAccountView.firstView(owner: self)
        sourceAccountView.addSubview(sourceAccountInfoView!)
        sourceAccountInfoView?.isUserInteractionEnabled = false
        sourceAccountInfoView?.acessoryView.isHidden = true
        sourceAccountInfoView?.snp.makeConstraints {(make) in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
        sourceAccountInfoView?.delegate = self
        
        tableView.register(UINib(nibName: R.nib.ncbDetailSavingFinalSettlementTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbDetailSavingFinalSettlementTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.estimatedSectionHeaderHeight = 100
//        tableView.sectionHeaderHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight =  50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        
        p = NCBSavingAccountPresenter()
        p?.delegate = self
//        p?.getDetailFinalSettlementSavingAccount(params: createDetailSFSParam())
    }
    
    func createDetailSFSParam() -> [String : Any] {
        let params: [String : Any] = [
            "username": NCBShareManager.shared.getUser()?.username ?? "",
            "cifno": NCBShareManager.shared.getUser()?.cif ?? 0,
            "acctNo" : acctNo ?? "",
            "savingNo" : savingNo ?? ""
        ]
        print(params)
        return params
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        setHeaderTitle("Tất toán tiết kiệm")
    }
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    
    override func defaultSourceAccount() {
        if listPaymentAccount.count == 0 {
            return
        }
        
        let result = listPaymentAccount.sorted() {
            ($0.curBal ?? 0.0) > ($1.curBal ?? 0.0)
        }
        
        listPaymentAccount = result
        
        SVProgressHUD.show()
        p?.getDetailFinalSettlementSavingAccount(params: createDetailSFSParam())
    }
    
    fileprivate func setupStructData() {
        if let sourceSelected = listPaymentAccount.first(where: { $0.acctNo == detailFinalSettlementSavingAccount?.payoutPr }) {
            sourceAccount = sourceSelected
        } else {
            sourceAccount = listPaymentAccount[0]
        }
        
        sourceAccount?.isSelected = true
        
        sourceAccountInfoView?.lbSourceAccount.text = "Tài khoản hưởng gốc, lãi"
        sourceAccountInfoView?.setSourceAccount(sourceAccount?.acctNo)
        sourceAccountInfoView?.setSourceName(sourceAccount?.acName)
        sourceAccountInfoView?.setSourceBalance(sourceAccount?.curBal)
        
        if let dataDetail = detailFinalSettlementSavingAccount {
            listDetailInfo.append(DetailFinalSettlementInfo(title1: "Số tài khoản", value1: "", title2: dataDetail.acctNo, value2: dataDetail.term))

            listDetailInfo.append(DetailFinalSettlementInfo(title1: "Số dư hiện tại", value1: dataDetail.getSurplus(), title2: "", value2: ""))
            listDetailInfo.append(DetailFinalSettlementInfo(title1: "Ngày mở/đáo hạn gần nhất", value1: dataDetail.openDate ?? "", title2: "", value2: ""))
            listDetailInfo.append(DetailFinalSettlementInfo(title1: "Ngày đến hạn", value1: dataDetail.matDate ?? "", title2: "", value2: ""))
            listDetailInfo.append(DetailFinalSettlementInfo(title1: "Lãi suất", value1: "\(dataDetail.intrate ?? 0.0)%", title2: "", value2: ""))
            listDetailInfo.append(DetailFinalSettlementInfo(title1: "Kỳ lĩnh lãi", value1: dataDetail.kyLinhlai ?? "", title2: "", value2: ""))
            if let type = dataDetail.typeId{
                if type == "GG"{
                    listDetailInfo.append(DetailFinalSettlementInfo(title1: "Sản phẩm", value1: "Tiết kiệm tích luỹ", title2: "", value2: ""))
                }else{
                    listDetailInfo.append(DetailFinalSettlementInfo(title1: "Sản phẩm", value1: "Tiết kiệm điện tử I-Savings", title2: "", value2: ""))
                }
            }
        }
        tableView.reloadData()
    }
}
extension NCBDetailSavingFinalSettlementAccountViewController: NCBSourceAccountViewDelegate{
    func sourceDidSelect() {
        showOriginalAccountList()
    }
    
    @objc fileprivate func showOriginalAccountList() {
        if let controller = R.storyboard.bottomSheet.ncbSourceAccountViewController() {
            controller.titleStr = "Chọn tài khoản hưởng gốc, lãi"
            showBottomSheet(controller: controller, size: 350)
            controller.delegate = self
            controller.setupData(listPaymentAccount)
        }
    }
}
extension NCBDetailSavingFinalSettlementAccountViewController: NCBSourceAccountViewControllerDelegate{
    func didSelectSourceAccount(_ account: NCBDetailPaymentAccountModel) {
        self.sourceAccountInfoView?.setSourceAccount(account.acctNo)
        self.sourceAccountInfoView?.setSourceName(account.acName)
        self.sourceAccountInfoView?.setSourceBalance(account.curBal)
        self.sourceAccount = account
        closeBottomSheet()
    }
}
extension NCBDetailSavingFinalSettlementAccountViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listDetailInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbDetailSavingFinalSettlementTableViewCell.identifier, for: indexPath) as! NCBDetailSavingFinalSettlementTableViewCell
        cell.infos = self.listDetailInfo[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
}
extension NCBDetailSavingFinalSettlementAccountViewController:NCBSavingAccountPresenterDelegate{
    func getDetailFinalSettlementSavingAccount(savingAccount: NCBDetailSettlementSavingAccountModel?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let _error = error {
            showAlert(msg: _error)
            return
        }
        
        if let data = savingAccount {
            self.detailFinalSettlementSavingAccount = data
            setupStructData()
        }
        
        tableView.reloadData()
    }
}
