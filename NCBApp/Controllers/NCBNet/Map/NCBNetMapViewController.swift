//
//  NCBNetMapViewController.swift
//  NCBApp
//
//  Created by Thuan on 8/12/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import MapKit

class NCBNetMapViewController: NCBBaseViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    fileprivate let locationManager = CLLocationManager()
    fileprivate var currentLocation: CLLocation?
    var dataModels = [NCBNetBranchModel]()
    var currentItem: NCBNetBranchModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func showNavigationBarBackground() -> Bool {
        return true
    }
}

extension NCBNetMapViewController {
    
    override func setupView() {
        super.setupView()
        
        if let lat = currentItem?.latitude, let lon = currentItem?.longitude {
            let viewRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: Double(lat) ?? 0.0, longitude: Double(lon) ?? 0.0), latitudinalMeters: 5000, longitudinalMeters: 5000)
            mapView.setRegion(viewRegion, animated: false)
        } else {
            locationManager.requestWhenInUseAuthorization()
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
            }
        }
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.isZoomEnabled = true
        
        var coords = [CLLocation]()
        for item in dataModels {
            coords.append(CLLocation(latitude: Double(item.latitude ?? "") ?? 0.0, longitude: Double(item.longitude ?? "") ?? 0.0))
        }
        addAnnotations(coords: coords)
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setCustomHeaderTitle("Mạng lưới NCB")
    }
    
    fileprivate func addAnnotations(coords: [CLLocation]){
        var i = 0
        for coord in coords {
            let CLLCoordType = CLLocationCoordinate2D(latitude: coord.coordinate.latitude,
                                                      longitude: coord.coordinate.longitude);
            let anno = MKPointAnnotation();
            anno.coordinate = CLLCoordType;
            anno.title = dataModels[i].getDisplayName
            mapView.addAnnotation(anno)
            i += 1
        }
    }
    
}

extension NCBNetMapViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if currentLocation == nil {
            if let userLocation = locations.last {
                let viewRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
                mapView.setRegion(viewRegion, animated: false)
            }
        }
        currentLocation = locations.last
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        } else{
            let pinIdent = "Pin";
            var pinView: MKAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: pinIdent) {
                dequeuedView.annotation = annotation
                pinView = dequeuedView
            } else{
                pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: pinIdent)
            }
            pinView.image = R.image.ic_branch_pin()
            return pinView
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let title = view.annotation?.title ?? ""
        let data = dataModels.first(where: { $0.getDisplayName == title })
        let popupDetail = R.nib.ncbPinDetailView.firstView(owner: self)!
        popupDetail.lbName.text = data?.getDisplayName
        popupDetail.lbAddress.text = data?.address
        if let phone = data?.phone {
            popupDetail.lbPhone.text = "Tel: \(phone)"
        }
        showPopupView(sourceView: popupDetail, size: 140)
    }
    
}
