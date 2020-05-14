//
//  NCBHomeMenuIconView.swift
//  NCBApp
//
//  Created by Thuan on 4/2/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

//struct MenuIconModel {
//    var image = ""
//    var title = ""
//}

protocol NCBHomeMenuIconViewDelegate: NSObject {
    func didSelectMenuItem(item: NCBMenuIconModel)
}

class NCBHomeMenuIconView: UIView {
    
    //MARK: Outlets

    @IBOutlet weak var colView: UICollectionView!
    
    //MARK: Properties
    
    fileprivate var dataModels = [NCBMenuIconModel]()
    weak var delegate: NCBHomeMenuIconViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        colView.register(UINib(nibName: R.nib.ncbHomeMenuIconCollectionViewCell.name, bundle: nil), forCellWithReuseIdentifier: R.reuseIdentifier.ncbHomeMenuIconCollectionViewCellID.identifier)
        colView.delegate = self
        colView.dataSource = self
    }

}

extension NCBHomeMenuIconView {
    
    func reloadData() {
        dataModels = getMainMenuIcon(true)
        colView.reloadData()
    }
    
}

extension NCBHomeMenuIconView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.ncbHomeMenuIconCollectionViewCellID.identifier, for: indexPath) as! NCBHomeMenuIconCollectionViewCell
        let item = dataModels[indexPath.row]
        cell.lbTitle.text = item.title
        cell.iconView.image = UIImage(named: item.image)?.withRenderingMode(.alwaysTemplate)
        cell.iconView.tintColor = UIColor.white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (appDelegate.window!.frame.size.width - 70)/3
        return CGSize(width: width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectMenuItem(item: dataModels[indexPath.row])
    }
    
}

extension NCBSetupServiceViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
