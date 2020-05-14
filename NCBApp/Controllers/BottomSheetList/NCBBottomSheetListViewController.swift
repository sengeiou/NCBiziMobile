//
//  NCBBottomSheetListViewController.swift
//  NCBApp
//
//  Created by Thuan on 7/26/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

typealias BottomSheetCallback = (String, Int) -> (Void)

struct BottomSheetStringItem {
    var title = ""
    var isCheck: Bool?
    
    init(title: String, isCheck: Bool? = nil) {
        self.title = title
        self.isCheck = (isCheck != nil) ? isCheck : false
    }
}

protocol NCBBottomSheetListViewControllerDelegate {
    func bottomSheetListDidSelectItem(_ item: String, index: Int)
}

class NCBBottomSheetListViewController: NCBBaseViewController {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var wrapSearchView: UIView!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tblView: UITableView!
    
    //MARK: Properties
    fileprivate var strTitle: String?
    fileprivate var items = [BottomSheetStringItem]()
    fileprivate var filterItems = [BottomSheetStringItem]()
    fileprivate var isHasOptionItem = false
    fileprivate var isHasSearchView = false
    fileprivate var isFilter = false
    fileprivate var blurItemSelected = false
    var itemDidSelect: BottomSheetCallback?
    var delegate: NCBBottomSheetListViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension NCBBottomSheetListViewController {
    
    override func setupView() {
        super.setupView()
        
        searchContainerView.addShadow(offset: CGSize(width: 0, height: 0), color: UIColor.black, opacity: 0.13, radius: 6)
        
        tfSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        tfSearch.font = semiboldFont(size: 14)
        tfSearch.textColor = ColorName.holderText.color
        tfSearch.attributedPlaceholder = NSAttributedString(string: "Tìm kiếm",
                                                            attributes: [NSAttributedString.Key.foregroundColor: ColorName.holderText.color!])
        
        if !isHasSearchView {
            wrapSearchView.isHidden = true
            for constraint in wrapSearchView.constraints {
                if constraint.firstAttribute == .height {
                    constraint.constant = 0
                    break
                }
            }
        }
        
        lbTitle.font = semiboldFont(size: 14)
        lbTitle.textColor = ColorName.blurNormalText.color
        lbTitle.text = strTitle
        
        tblView.register(UINib(nibName: R.nib.ncbBottomSheetListTableCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbBottomSheetListTableCellID.identifier)
        tblView.separatorStyle = .none
        tblView.estimatedRowHeight = 50
        tblView.rowHeight = UITableView.automaticDimension
        tblView.delegate = self
        tblView.dataSource = self
    }
    
    override func loadLocalized() {
        super.loadLocalized()
    }
    
    func setData(_ title: String, items: [BottomSheetStringItem], isHasOptionItem: Bool, isHasSearchView: Bool? = false, blurItemSelected: Bool? = false) {
        self.strTitle = title
        self.items = items
        self.isHasOptionItem = isHasOptionItem
        self.isHasSearchView = isHasSearchView ?? false
        self.blurItemSelected = blurItemSelected ?? false
    }
    
    @objc func textFieldDidChange(_ tf: UITextField) {
        if tf.text == "" {
            isFilter = false
        } else {
            isFilter = true
        }
        
        filterItems = items.filter({ $0.title.lowercased().contains(tf.text!.trim.lowercased()) })
        tblView.reloadData()
    }
    
}

extension NCBBottomSheetListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFilter {
            return filterItems.count
        }
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbBottomSheetListTableCellID.identifier, for: indexPath) as! NCBBottomSheetListTableCell
        let item = (isFilter ? filterItems : items)[indexPath.row]
        cell.lbTitle.text = item.title
        cell.isHiddenOption(!isHasOptionItem)
        cell.checkBtn.isSelected = item.isCheck!
        cell.lbTitle.alpha = (item.isCheck == true && blurItemSelected == true) ? 0.5 : 1.0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = delegate {
            delegate.bottomSheetListDidSelectItem((isFilter ? filterItems : items)[indexPath.row].title, index: indexPath.row)
        } else {
            itemDidSelect?((isFilter ? filterItems : items)[indexPath.row].title, indexPath.row)
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50
//    }
    
}
