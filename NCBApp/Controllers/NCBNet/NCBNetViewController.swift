//
//  NCBNetViewController.swift
//  NCBApp
//
//  Created by Thuan on 8/7/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import CoreLocation

class NCBNetViewController: NCBNetBaseUIViewController {
    
    fileprivate var p: NCBNetPresenter?
    fileprivate var dataModels = [NCBNetBranchModel]()
    fileprivate var filteredModels = [NCBNetBranchModel]()
    fileprivate let locationManager = CLLocationManager()
    fileprivate var lat = 0.0
    fileprivate var lon = 0.0
    fileprivate var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension NCBNetViewController {
    
    override func setupView() {
        super.setupView()
        
        p = NCBNetPresenter()
        p?.delegate = self
        
        tblView.register(UINib(nibName: R.nib.ncbNetTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbNetTableViewCellID.identifier)
        tblView.separatorStyle = .none
        tblView.rowHeight = UITableView.automaticDimension
        tblView.estimatedRowHeight = 100
        tblView.delegate = self
        tblView.dataSource = self
        
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        SVProgressHUD.show()
        p?.getAllBranch()
    }
    
    override func textFieldDidChange(_ tf: UITextField) {
        super.textFieldDidChange(tf)
        
        filteredModels = dataModels.filter({ ($0.name?.lowercased() ?? "").contains(tf.text!.trim.lowercased())
            || ($0.address?.lowercased() ?? "").contains(tf.text!.trim.lowercased())
            || ($0.phone?.lowercased() ?? "").contains(tf.text!.trim.lowercased())
        })
        tblView.reloadData()
    }
    
    override func changeType(_ sender: UIButton) {
        super.changeType(sender)
        tfSearch.text = ""
        textFieldDidChange(tfSearch)
        
        SVProgressHUD.show()
        switch sender.tag {
        case NetButtonType.branch.rawValue:
            p?.getAllBranch()
        default:
            p?.getATM()
        }
    }
    
}

extension NCBNetViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (isFilter ? filteredModels: dataModels).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbNetTableViewCellID.identifier, for: indexPath) as! NCBNetTableViewCell
        let item = (isFilter ? filteredModels: dataModels)[indexPath.row]
        cell.setData(item, lat: lat, lon: lon)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = R.storyboard.exchangeRate.ncbNetMapViewController() {
            vc.currentItem = dataModels[indexPath.row]
            vc.dataModels = dataModels.filter({ $0.latitude != nil && $0.longitude != nil })
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension NCBNetViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if currentLocation == nil {
            guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
            lat = locValue.latitude
            lon = locValue.longitude
            
            if dataModels.count > 0 {
                tblView.reloadData()
            }
        }
        currentLocation = locations.last
    }
    
}

extension NCBNetViewController: NCBNetPresenterDelegate {
    
    func getAllBranchCompleted(branchList: [NCBNetBranchModel]?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        dataModels = branchList ?? []
        tblView.reloadData()
    }
    
    func getATMCompleted(atmList: [NCBNetBranchModel]?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        dataModels = atmList ?? []
        tblView.reloadData()
    }
    
}
