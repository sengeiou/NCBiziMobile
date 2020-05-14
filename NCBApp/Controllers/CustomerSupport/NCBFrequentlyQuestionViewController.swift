//
//  NCBFrequentlyQuestionViewController.swift
//  NCBApp
//
//  Created by Van Dong on 07/08/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBFrequentlyQuestionViewController: NCBBaseViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: R.nib.ncbQuestionTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.nib.ncbQuestionTableViewCell.identifier)
            tableView.separatorStyle = .none
            tableView.allowsSelection = false

            tableView.tableFooterView = UIView(frame: CGRect.zero)
            tableView.backgroundColor = UIColor.clear
        }
    }
    fileprivate var frequentlyQuestion:[NCBQuestionAnswerModel] = []
    var p: NCBCustomerSupportPresenter?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func setupView() {
        super.setupView()
        
        tableView.delegate = self
        tableView.dataSource = self

        p = NCBCustomerSupportPresenter()
        p?.delegate = self
        var params: [String: Any] = [:]
        params["cifno"] = NCBShareManager.shared.getUser()?.cif
        params["userId"] = NCBShareManager.shared.getUser()?.username
        params["cardType"] = ""
        SVProgressHUD.show()
        p?.getQuestionAnswer(params: params)
        SVProgressHUD.show()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.reloadData()
    }
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    override func loadLocalized() {
        super.loadLocalized()
        setHeaderTitle("Câu hỏi thường gặp")
    }

}

extension NCBFrequentlyQuestionViewController: NCBCustomerSupportPresenterDelegate {
    func getQuestionAnswer(services: [NCBQuestionAnswerModel]?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let _error = error {
            showAlert(msg: _error)
        }
        if let data = services {
            frequentlyQuestion = data
        }
        tableView.reloadData()
    }
}

extension NCBFrequentlyQuestionViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frequentlyQuestion.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbQuestionTableViewCell.identifier, for: indexPath) as! NCBQuestionTableViewCell
        let item = frequentlyQuestion[indexPath.row]
        cell.setupData(item)
        cell.numberQuestion.text = String(indexPath.row + 1)
        cell.checkbtn.tag = indexPath.row
        cell.checkbtn.addTarget(self, action: #selector(showAnswer(_ :)), for: .touchUpInside)
        return cell
    }
    
    @objc func showAnswer(_ sender: UIButton) {
        let item = frequentlyQuestion[sender.tag]
        item.isOpened = !item.isOpened
        tableView.reloadData()
    }


}

