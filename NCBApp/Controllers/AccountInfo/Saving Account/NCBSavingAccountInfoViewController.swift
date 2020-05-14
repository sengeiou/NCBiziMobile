//
//  NCBSavingAccountInfoViewController.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/17/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

//protocol SectionHeaderViewDelegate {
//    func sectionHeaderView(sectionHeaderView: SectionHeaderView, sectionOpened: Int)
//    func sectionHeaderView(sectionHeaderView: SectionHeaderView, sectionClosed: Int)
//}

enum SavingAccountType: String {
    case Normal = "Tiết kiệm I-Saving"
    case Accumulated = "Tiết kiệm tích luỹ"
}

class NCBSavingAccountInfoViewController: NCBBaseViewController {
    
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    
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
    
    // MARK: - Properties
    
    var generalSavingAccountInfo: NCBGroupSavingAccountModel? {
        didSet {
            totalAmountLbl.text = generalSavingAccountInfo?.getTotalBalance
            totalAmountUSDLbl.text = generalSavingAccountInfo?.getTotalBalanceUSD
            totalLbl.text = "\(getCountSavingAccounts(info: generalSavingAccountInfo)) tài khoản tiết kiệm"
        }
    }
    
    var savingAccountInfoPresenter: NCBSavingAccountInfoPresenter?
    var sortIndex: Int = 0
    fileprivate var selectionIndexArr = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSortRightBarItem()
    }
    
    func addSortRightBarItem() {
        let sortButton = UIButton(frame: CGRect(x: -10, y: 0, width: 50, height: 40))
        sortButton.setImage(R.image.ic_sort(), for: .normal)
        sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        sortButton.contentEdgeInsets = UIEdgeInsets(top: hasTopNotch ? 10 : 25, left: 15, bottom: 0, right: 0)
        let sortItem = UIBarButtonItem(customView: sortButton)
        navigationItem.rightBarButtonItem = sortItem
    }
    
    @objc func sortButtonTapped() {
        showSortItemAction()
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
    
    fileprivate func showSortItemAction() {
//        ["Mặc định", "Số tiền từ Cao xuống Thấp", "Số tiền từ  Thấp lên Cao"]
        if let vc = R.storyboard.bottomSheet.ncbBottomSheetListViewController() {
            vc.delegate = self
            
            vc.setData("Sắp xếp tài khoản tiết kiệm", items: [BottomSheetStringItem(title: "Mặc định", isCheck: (sortIndex == 0)), BottomSheetStringItem(title: "Số tiền từ cao đến thấp", isCheck: (sortIndex == 1)), BottomSheetStringItem(title: "Số tiền từ thấp đến cao", isCheck: (sortIndex == 2))], isHasOptionItem: true)
            showBottomSheet(controller: vc, size: 300)
        }
    }
}

extension NCBSavingAccountInfoViewController {
    override func setupView() {
        super.setupView()
        
        setHeaderTitle("TÀI KHOẢN TIẾT KIỆM")
        
        savingAccountInfoPresenter = NCBSavingAccountInfoPresenter()
        SVProgressHUD.show()
        savingAccountInfoPresenter?.getListSavingAccount(params: createGroupSavingAccountParams())
        savingAccountInfoPresenter?.delegate = self
    }
    
    func createGroupSavingAccountParams() -> [String : Any] {
        
        let params: [String : Any] = [
            "sort" : sortIndex != 0 ? sortIndex : "",
           "username" : NCBShareManager.shared.getUser()?.username ?? "",
           "cifno" : NCBShareManager.shared.getUser()?.cif ?? ""
        ]
        
        return params
    }
}

extension NCBSavingAccountInfoViewController: NCBDropdownTextFieldDelegate {
    func didSelectTerm(with text: String?, of textField: NCBDropdownTextField?) {
        SVProgressHUD.show()
        savingAccountInfoPresenter?.getListSavingAccount(params: createGroupSavingAccountParams())
    }
}

extension NCBSavingAccountInfoViewController: NCBSavingAccountInfoPresenterDelegate {
    func getGroupSavingAccountCompleted(savingAccount: NCBGroupSavingAccountModel?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let _error = error {
            showAlert(msg: _error)
        }
        
        self.generalSavingAccountInfo = savingAccount
        for i in  0 ..< (generalSavingAccountInfo?.isavingGroup?.count ?? 0) {
            selectionIndexArr.append(i)
        }
        savingAccountInfoTbl.reloadData()
    }
}

extension NCBSavingAccountInfoViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return generalSavingAccountInfo?.isavingGroup?.count ?? 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = R.nib.ncbSavingAccountInfoHeader.firstView(owner: nil)!
        header.savingAccountNameLbl.text = generalSavingAccountInfo?.isavingGroup?[section].grpName

        header.expandBtn.isSelected = selectionIndexArr.contains(where: { $0 == section })
        header.topLineView.isHidden = header.expandBtn.isSelected
        
        header.isUserInteractionEnabled = true
        header.tag = section
        let gesture = UITapGestureRecognizer(target: self, action: #selector(toggleCollapse(_:)))
        header.addGestureRecognizer(gesture)
        return header
    }
    
    @objc func toggleCollapse(_ sender: UIGestureRecognizer) {
        let section = sender.view?.tag ?? 0
        
        if selectionIndexArr.contains(where: { $0 == section }), let index = selectionIndexArr.firstIndex(where: { $0 == section }) {
            selectionIndexArr.remove(at: index)
        } else {
            selectionIndexArr.append(section)
        }
        
        // Reload section
        savingAccountInfoTbl.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectionIndexArr.contains(where: { $0 == section }) ? (generalSavingAccountInfo?.isavingGroup?[section].isavings?.count ?? 0) : 0
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

extension NCBSavingAccountInfoViewController: NCBBottomSheetListViewControllerDelegate {
    func bottomSheetListDidSelectItem(_ item: String, index: Int) {
        sortIndex = index
        closeBottomSheet()
        SVProgressHUD.show()
        savingAccountInfoPresenter?.getListSavingAccount(params: createGroupSavingAccountParams())
    }
}

