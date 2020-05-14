//
//  NCBCardListViewController.swift
//  NCBApp
//
//  Created by Thuan on 8/8/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import SnapKit
import Kingfisher

class NCBCardListViewController: NCBBaseViewController {
    
    fileprivate var tblView: UITableView!
    fileprivate var p: NCBCardListPresenter?
    var cardList = [NCBCardModel]()
    fileprivate var indexParam = 0
    
    @objc var cardTypeParams: [String] {
        return [""]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        indexParam = 0
        cardList.removeAll()
        getCardList()
    }
    
    fileprivate func getCardList() {
        if indexParam > cardTypeParams.count - 1 {
            if self.cardList.count == 0 {
                showError(msg: ErrorConstant.crdCardListNoData.getMessage() ?? "Quý khách chưa có thẻ tại NCB. Vui lòng chọn Phát hành mới thẻ để đăng ký phát hành thẻ mới") {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            return
        }
        
        let cardType = cardTypeParams[indexParam]
        
        var params: [String: Any] = [:]
        params["cifno"] = NCBShareManager.shared.getUser()!.cif
        params["userId"] = NCBShareManager.shared.getUser()!.username
        params["cardType"] = cardType
        
        if indexParam == 0 {
            SVProgressHUD.show()
        }
        p?.getCardList(params: params)
    }
    
}

extension NCBCardListViewController {
    
    override func setupView() {
        super.setupView()
        
        view.backgroundColor = UIColor.white
        
        let bgView = UIImageView()
        bgView.contentMode = .scaleToFill
        bgView.image = R.image.transaction_info_bg()
        view.addSubview(bgView)
        
        bgView.snp.makeConstraints { (make) in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
        
        tblView = UITableView()
        tblView.separatorStyle = .none
        tblView.backgroundColor = UIColor.clear
        tblView.register(UINib(nibName: R.nib.ncbCardListTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbCardListTableViewCellID.identifier)
        tblView.delegate = self
        tblView.dataSource = self
        view.addSubview(tblView)
        
        let maxY = navHeight + (hasTopNotch ? 24 :34)
        
        tblView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.additionalSafeAreaInsets.top).offset(maxY)
                make.bottom.equalTo(self.additionalSafeAreaInsets.bottom)
            } else {
                make.top.equalToSuperview().offset(maxY)
                make.bottom.equalToSuperview()
            }
        }
        
        p = NCBCardListPresenter()
        p?.delegate = self
    }
    
    override func loadLocalized() {
        super.loadLocalized()
    }
    
    @objc func applyCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbCardListTableViewCellID.identifier, for: indexPath) as! NCBCardListTableViewCell
        let item = cardList[indexPath.row]
        cell.creditCardInfoView.setData(item)
        cell.otherBtn.tag = indexPath.row
        cell.mainBtn.tag = indexPath.row
        return cell
    }
    
}

extension NCBCardListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return applyCell(tableView, cellForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 186
    }
    
}

extension NCBCardListViewController: NCBCardListPresenterDelegate {
    
    func getCardListCompleted(cardList: [NCBCardModel]?, error: String?) {
        if indexParam == cardTypeParams.count - 1 {
            SVProgressHUD.dismiss()
        }
        
        indexParam += 1
        
        if let _ = error {
//            SVProgressHUD.dismiss()
//            showAlert(msg: _error)
            getCardList()
            return
        }
        
        self.cardList += cardList ?? []
        tblView.reloadData()
        getCardList()
    }
    
}
