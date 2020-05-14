//
//  NCBSavedListSlideView.swift
//  NCBApp
//
//  Created by Thuan on 7/31/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

protocol NCBSavedListSlideViewDelegate {
    func savedListDidSelectItem(index: Int)
}

class NCBSavedListSlideView: UIView {
    
    fileprivate var dataModels = [NCBPayBillSavedModel]()
    @IBOutlet weak var colView: UICollectionView!
    
    var delegate: NCBSavedListSlideViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        colView.register(UINib(nibName: R.nib.ncbSavedListSlideCollectionViewCell.name, bundle: nil), forCellWithReuseIdentifier: R.reuseIdentifier.ncbSavedListSlideCollectionViewCellID.identifier)
        colView.delegate = self
        colView.dataSource = self
    }
    
    func setData(_ dataModels: [NCBPayBillSavedModel]) {
        self.dataModels = dataModels
        colView.reloadData()
    }
    
}

extension NCBSavedListSlideView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.ncbSavedListSlideCollectionViewCellID.identifier, for: indexPath) as! NCBSavedListSlideCollectionViewCell
        let item = dataModels[indexPath.row]
        
        cell.lbName.text = item.memName
        cell.lbCode.text = "Mã khách hàng\n\(item.billNo ?? "")"
        
        var named = ""
        switch item.serviceCode {
        case PayType.NUOC.rawValue:
            named = R.image.ic_water.name
        case PayType.DTCDTS.rawValue:
            named = R.image.ic_postpaid_mobile.name
        case PayType.CAP.rawValue:
            named = R.image.ic_tv.name
        case PayType.DTCDCD.rawValue:
            named = R.image.ic_phone.name
        case PayType.DIEN.rawValue:
            named = R.image.ic_electric.name
        case PayType.NET.rawValue:
            named = R.image.ic_internet.name
        default:
            named = ""
        }
        
        cell.iconView.image = UIImage(named: named)?.withRenderingMode(.alwaysTemplate)
        cell.iconView.tintColor = UIColor.white
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 145, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.savedListDidSelectItem(index: indexPath.row)
    }
    
}
