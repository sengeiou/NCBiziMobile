//
//  NCBSeachDealOnAccountViewController.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/10/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBSearchDealOnAccountViewController: NCBBaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var searchDealTbl: UITableView! {
        didSet {
            searchDealTbl.register(R.nib.ncbSearchDealTableViewCell)
            searchDealTbl.register(R.nib.ncbSubPaymentAccountTableViewCell)
            searchDealTbl.delegate = self
            searchDealTbl.dataSource = self
        }
    }
    
//    @IBOutlet weak var coupleAccountScrV: UIScrollView!
    
    @IBOutlet weak var containerScrollView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Properties
    var listAccountArray: [[NCBDetailPaymentAccountModel]] = []
    var listAccount: [NCBDetailPaymentAccountModel] = []
    var listSubAccount: [NCBDetailPaymentAccountModel] = []
    var listAccountViewArray: [UIView] = []
    var selectIndex: Int = 0
    
    var listDealHistoryOnSearch: [NCBSearchHistoryDealItemModel] = []
    
    var p: NCBSearchDealOnAccountPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @objc func tapOnAccountView(sender: UITapGestureRecognizer) {
        selectIndex = sender.view?.tag ?? 0
        for view in listAccountViewArray {
            if view.tag == sender.view?.tag {
                view.alpha = 1.0
            } else {
                view.alpha = 0.5
            }
        }
        listDealHistoryOnSearch = []
        searchDealTbl.reloadData()
    }
    
}

extension NCBSearchDealOnAccountViewController {
    override func setupView() {
        super.setupView()
        
        setupAccountArray()
        setupScrollView()
        
        p = NCBSearchDealOnAccountPresenter()
        p?.delegate = self
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle("TÌM KIẾM GIAO DỊCH")
    }
    
    func setupAccountArray(){
        listAccountArray = []
        listAccountArray = Array(repeating: [], count: listAccount.count % 2 == 0 ? Int(listAccount.count / 2) : Int(listAccount.count / 2) + 1)
        listSubAccount = listAccount
        
        for i in 0..<listAccountArray.count {
            for j in 0..<listAccount.count {
                while listAccountArray[i].count < 2 && listAccount.count > 0 {
                    listAccountArray[i].append(listAccount[j])
                    listAccount.remove(at: 0)
                }
            }
        }
    }
    
    func setupScrollView() {
        for i in 0..<listAccountArray.count{
            let stackViewContainer: UIStackView = {
                let view = UIStackView()
                
                view.axis = .horizontal
                view.spacing = 10
                
                return view
            }()
            scrollView.contentSize = CGSize(width: appDelegate.window!.frame.width * CGFloat(listAccount.count), height: containerScrollView.frame.height)
            scrollView.isPagingEnabled = true
            stackViewContainer.frame = CGRect(x: appDelegate.window!.frame.width * CGFloat(i), y: 0, width: appDelegate.window!.frame.width, height: scrollView.frame.height)
            
            
            for j in 0..<listAccountArray[i].count {
                let subPaymentAccountDetailView = R.nib.ncbSubPaymentAccountDetailView.firstView(owner: nil)!
                subPaymentAccountDetailView.tag = j + i * 2
                subPaymentAccountDetailView.accountInfo = listAccountArray[i][j]
                
                let gesture = UITapGestureRecognizer(target: self, action: #selector(tapOnAccountView(sender:)))
                subPaymentAccountDetailView.addGestureRecognizer(gesture)
                listAccountViewArray.append(subPaymentAccountDetailView)
                stackViewContainer.addArrangedSubview(subPaymentAccountDetailView)
            }
            stackViewContainer.distribution = .fillEqually
            scrollView.addSubview(stackViewContainer)
        }
        setupViewArray()
    }
    
    func setupViewArray() {
        for view in listAccountViewArray{
            if view.tag == 0 {
                view.alpha = 1.0
            }else{
                view.alpha = 0.5
            }
        }
    }
}

extension NCBSearchDealOnAccountViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch  section {
        case 0:
            return 1
        case 1:
            return listDealHistoryOnSearch.count
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbSearchDealTableViewCell.identifier, for: indexPath) as! NCBSearchDealTableViewCell
            cell.searchItemCallBack = { [weak self] receiver, fromAmount, toAmount in
                let params: [String : Any] = [
                    "cif": self?.listSubAccount[self?.selectIndex ?? 0].cifNo ?? "",
                    "accountNo": self?.listSubAccount[self?.selectIndex ?? 0].acctNo ?? "",
                    "receiver": receiver ?? "",
                    "fromAmount": fromAmount ?? 0.0,
                    "toAmount": toAmount ?? 0.0
                ]
                SVProgressHUD.show()
                self?.p?.getListDealHistoryOnAccount(params: params)
            }
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbSubPaymentAccountTableViewCell.identifier, for: indexPath) as! NCBSubPaymentAccountTableViewCell
            
            cell.dealHistoryOnSearch = listDealHistoryOnSearch[indexPath.row]
            return cell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            if let _vc = R.storyboard.accountInfo.ncbDetailAccountViewController() {
                _vc.viewAccountMode = .detailDealHistory
                _vc.sequenseNo = String(listDealHistoryOnSearch[indexPath.row].seqno ?? 0)
                _vc.accountNo = listDealHistoryOnSearch[indexPath.row].acctno ?? ""
                self.navigationController?.pushViewController(_vc, animated: true)
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

extension NCBSearchDealOnAccountViewController: NCBSearchDealOnAccountPresenterDelegate {
    func getDealHistoryCompleted(listAccountCA: [NCBSearchHistoryDealItemModel]?, error: String?) {
        SVProgressHUD.dismiss()
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        if listAccountCA?.count == 0 {
            showAlert(msg: "Không tìm thấy giao dịch tìm kiếm. Quý khách vui lòng kiểm tra lại")
            return
        }
        self.listDealHistoryOnSearch = listAccountCA ?? []
        self.searchDealTbl.reloadData()
        if listDealHistoryOnSearch.count > 0 {
            self.searchDealTbl.scrollToRow(at: IndexPath(row: 0, section: 1), at: .top, animated: true)
        }
    }
}
