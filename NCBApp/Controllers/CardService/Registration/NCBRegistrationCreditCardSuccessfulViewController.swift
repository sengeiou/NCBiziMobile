//
//  NCBRegistrationCreditCardSuccessfulViewController.swift
//  NCBApp
//
//  Created by ADMIN on 8/1/19.
//  Copyright © 2019 tvo. All rights reserved.
//


import Foundation

class NCBRegistrationCreditCardSuccessfulViewController: NCBTransactionSuccessfulViewController {
    
    var accountName = ""
    var branch = ""
    var cardProducts = ""
    var cardClass = ""
    var pee:Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension NCBRegistrationCreditCardSuccessfulViewController {
    
    override func setupView() {
        super.setupView()
        
        infoTblView.register(UINib(nibName: R.nib.ncbRegistrationCreditCardSuccessfulTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbRegistrationCreditCardSuccessfulTableViewCellID.identifier)
        infoTblView.separatorStyle = .none
        infoTblView.estimatedSectionHeaderHeight = 120
        infoTblView.sectionHeaderHeight = UITableView.automaticDimension
        infoTblView.estimatedRowHeight = 100
        infoTblView.rowHeight = UITableView.automaticDimension
        infoTblView.delegate = self
        infoTblView.dataSource = self
        hiddenHeaderView()
        updateHeightInfoView(250)
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        setHeaderTitle("Giao dịch thành công")
    }
    
    override func continueAction() {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: NCBCardServiceViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            } else if controller.isKind(of: NCBGeneralAccountViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
}


extension NCBRegistrationCreditCardSuccessfulViewController {
    
    func setData(branch: String, cardProduct: String, cardClass: String, pee:Double,accountName:String) {
        self.branch = branch
        self.cardProducts = cardProduct
        self.cardClass = cardClass
        self.pee = pee
        self.accountName = accountName
    }
}

extension NCBRegistrationCreditCardSuccessfulViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbRegistrationCreditCardSuccessfulTableViewCellID.identifier, for: indexPath) as! NCBRegistrationCreditCardSuccessfulTableViewCell
        return cell
        
    }
    
}

