//
//  NCBSavingAccountViewController.swift
//  NCBApp
//
//  Created by Thuan on 4/23/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

enum SavingType: Int {
    case tietkiem = 0
    case naptientietkiem
    case tattoantietkiem
}

struct SavingModel {
    var name = ""
    var icon = ""
    var type: SavingType = .tietkiem
}
class NCBSavingAccountViewController: NCBBaseViewController {
    
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var totalAmountLbl: NCBCurrencyLabel!
    @IBOutlet weak var totalAmountUSDLbl: NCBCurrencyLabel!
    @IBOutlet weak var savingAccountInfoTbl: UITableView! {
        didSet {
            savingAccountInfoTbl.register(UINib(nibName: R.nib.ncbNewSaveAccountCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbNewSaveAccountCell.identifier)
            savingAccountInfoTbl.delegate = self
            savingAccountInfoTbl.dataSource = self
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: Properties
    
    fileprivate let dataModels = [SavingModel(name: "Gửi tiết kiệm", icon: R.image.ic_feature_saving.name, type: .tietkiem), SavingModel(name: "Nộp thêm tiết kiệm tích lũy", icon: R.image.ic_feature_extra_saving.name, type: .naptientietkiem), SavingModel(name: "Tất toán tiết kiệm", icon: R.image.ic_feature_settlement_saving.name, type: .tattoantietkiem)]
    
    fileprivate var listSavingFinalSettlementAccount: [NCBFinalSettlementSavingAccountModel] = []
    var p: NCBSavingAccountPresenter?
    
    
    var generalSavingAccountInfo: NCBGroupSavingAccountModel? {
        didSet {
            totalAmountLbl.text = generalSavingAccountInfo?.getTotalBalance
            totalAmountUSDLbl.text = generalSavingAccountInfo?.getTotalBalanceUSD
            totalLbl.text = "\(getCountSavingAccounts(info: generalSavingAccountInfo)) tài khoản tiết kiệm"
        }
    }
    var savingAccountInfoPresenter: NCBSavingAccountInfoPresenter?
    var showBack = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !showBack {
            navigationItem.leftBarButtonItem = nil
        }
        
        //  Update general saving account
        updateSavingAccounts()
    }
    
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    
    func getCountSavingAccounts(info: NCBGroupSavingAccountModel?) -> Int {
        var counter = 0
        if let model = info {
            if let groups = model.isavingGroup, groups.count > 0 {
                for group in groups {
                    if let isavings = group.isavings, isavings.count > 0 {
                        counter += isavings.count
                    }
                }
            }
        }
        return counter
    }
    
    private func updateSavingAccounts() {
        SVProgressHUD.show()
        savingAccountInfoPresenter?.getListSavingAccount(params: createGroupSavingAccountParams())
    }
    
}
extension NCBSavingAccountViewController{
    override func setupView() {
        super.setupView()
        
        collectionView.register(UINib(nibName: R.nib.ncbHomeMenuIconCollectionViewCell.name, bundle: nil), forCellWithReuseIdentifier: R.reuseIdentifier.ncbHomeMenuIconCollectionViewCellID.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        p = NCBSavingAccountPresenter()
        p?.delegate = self
        p?.getSavingFinalSettlementAccounts(params: createSavingFinalSettlementParams())
        
        //  General saving info
        savingAccountInfoPresenter = NCBSavingAccountInfoPresenter()
        savingAccountInfoPresenter?.delegate = self

    }
    
    func createGroupSavingAccountParams() -> [String : Any] {
        let params: [String : Any] = [
            "sort" : "",
            "username" : NCBShareManager.shared.getUser()?.username ?? "",
            "cifno" : NCBShareManager.shared.getUser()?.cif ?? ""
        ]
        return params
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setCustomHeaderTitle("Tiết kiệm")
    }
    func createSavingFinalSettlementParams() -> [String : Any]{
        let param: [String : Any] = [
            "cifno" : NCBShareManager.shared.getUser()?.cif ?? ""
        ]
        return param
    }
}

extension NCBSavingAccountViewController: NCBSavingAccountPresenterDelegate{
    func getSavingFinalSettlementAccountsCompleted(savingAccounts: [NCBFinalSettlementSavingAccountModel]?, error: String?) {
        
        SVProgressHUD.dismiss()
        if let _error = error {
            showAlert(msg: _error)
            return
        }
        
        if let data = savingAccounts, data.count > 0 {
            listSavingFinalSettlementAccount = data
        }
    }
}

extension NCBSavingAccountViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.ncbHomeMenuIconCollectionViewCellID.identifier, for: indexPath) as! NCBHomeMenuIconCollectionViewCell
        let item = dataModels[indexPath.row]
        cell.lbTitle.text = item.name
        cell.iconView.image = UIImage(named: item.icon)?.withRenderingMode(.alwaysTemplate)
        cell.iconView.tintColor = UIColor.white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (appDelegate.window!.frame.size.width - 70)/3
        return CGSize(width: width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataModels[indexPath.row]
        
        switch item.type {
        case .tietkiem:
            var items = [BottomSheetDetailStringItem]()
            items.append(BottomSheetDetailStringItem(title: "Tiết kiệm thường/Tiền gửi có kỳ hạn", detail: "Lãi suất hấp dẫn cao hơn tiết kiệm truyền thống", isCheck: false))
            items.append(BottomSheetDetailStringItem(title: "Tiết kiệm tích luỹ ", detail: "Có thể nộp thêm tiền vài tào khoản tiết kiệm tích lũy bất cứ lúc nào", isCheck: false))
            if let vc = R.storyboard.sendSaving.ncbBottomSheetDetailListViewController() {
                vc.setData("Chọn sản phẩm tiết kiệm", items: items, isHasOptionItem: true)
                vc.delegate = self
                showBottomSheet(controller: vc, size: 330)
            }
        case .naptientietkiem:
            if let vc = R.storyboard.saving.ncbAddSavingAmountViewController() {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case .tattoantietkiem:
            if listSavingFinalSettlementAccount.count > 0{
                if let controller = R.storyboard.bottomSheet.ncbListSavingFinalSettlementAccountViewController() {
                    showBottomSheet(controller: controller, size: view.frame.height * 2 / 3)
                    controller.setupData(listSavingFinalSettlementAccount)
                }
            }else{
                showAlert(msg: "Quý khách không có tài khoản tiết kiệm có thể tất toán trực tuyến. Vui lòng kiểm tra lại")
            }
        }
    }
}

extension NCBSavingAccountViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return generalSavingAccountInfo?.isavingGroup?.count ?? 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = R.nib.ncbSavingAccountInfoHeader.firstView(owner: nil)!
        header.savingAccountNameLbl.text = generalSavingAccountInfo?.isavingGroup?[section].grpName
        header.expandBtn.isSelected = !(generalSavingAccountInfo?.isavingGroup?[section].isExpand ?? false)
        header.topLineView.isHidden = header.expandBtn.isSelected
        header.isUserInteractionEnabled = true
        header.tag = section
        let gesture = UITapGestureRecognizer(target: self, action: #selector(toggleCollapse(_:)))
        header.addGestureRecognizer(gesture)
        return header
    }
    
    @objc func toggleCollapse(_ sender: UIGestureRecognizer) {
        let section = sender.view?.tag ?? 0
        let collapsed = generalSavingAccountInfo?.isavingGroup?[section].isExpand
        
        // Toggle collapse
        generalSavingAccountInfo?.isavingGroup?[section].isExpand = !(collapsed ?? false)
        // Reload section
        savingAccountInfoTbl.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (generalSavingAccountInfo?.isavingGroup?[section].isExpand! ?? true) ? 0 : (generalSavingAccountInfo?.isavingGroup?[section].isavings?.count ?? 0)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbNewSaveAccountCell.identifier, for: indexPath) as! NCBNewSaveAccountCell
        cell.selectionStyle = .none
        cell.model = generalSavingAccountInfo?.isavingGroup?[indexPath.section].isavings?[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _vc = R.storyboard.accountInfo.ncbDetailSavingAccountInfoViewController() {
            if let item = self.generalSavingAccountInfo?.isavingGroup?[indexPath.section].isavings?[indexPath.row] {
                _vc.generalSavingAccountInfoModel = item
                self.navigationController?.pushViewController(_vc, animated: true)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NCBSavingAccountViewController: NCBSavingAccountInfoPresenterDelegate {
    func getGroupSavingAccountCompleted(savingAccount: NCBGroupSavingAccountModel?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let _error = error {
            showAlert(msg: _error)
        }
        
        self.generalSavingAccountInfo = savingAccount
        savingAccountInfoTbl.reloadData()
    }
}

extension NCBSavingAccountViewController: NCBBottomSheetDetailListViewControllerDelegate {
    func bottomSheetDetailListDidSelectItem(_ item: String, index: Int) {
        removeBottomSheet()
        
        if index  == 0 {
            if let vc = R.storyboard.sendSaving.ncbiSavingsViewController() {
                 vc.savingFormType = .ISavingSaving
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else {
            if let vc = R.storyboard.sendSaving.ncbiSavingsViewController() {
                vc.savingFormType = .AccumulateSaving
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
}
