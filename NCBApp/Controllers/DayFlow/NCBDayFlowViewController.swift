//
//  NCBDayFlowViewController.swift
//  NCBApp
//
//  Created by Thuan on 7/29/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import RSDayFlow

protocol NCBDayFlowViewControllerDelegate {
    func dateDidSelect(_ date: Date)
}

class NCBDayFlowViewController: NCBBaseViewController {
    
    var delegate: NCBDayFlowViewControllerDelegate?
    var dateSelected: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension NCBDayFlowViewController {
    
    override func setupView() {
        super.setupView()
        
        view.backgroundColor = UIColor.white
        setupCalendar()
    }
    
    override func loadLocalized() {
        super.loadLocalized()
    }
    
    fileprivate func setupCalendar() {
        let startDate = (Calendar.current as NSCalendar).date(byAdding: .month, value: -3, to: Date(), options: [])!
        let currentDate = Date()
        
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "vi")
        let datePickerView = NCBDFDatePickerView(frame: CGRect(x: 0, y: 40, width: self.view.frame.width, height: 430), calendar: calendar, start: startDate, end: currentDate)
        datePickerView.select(dateSelected)
        
        datePickerView.delegate = self
        datePickerView.dataSource = self
        view.addSubview(datePickerView)
    }
    
}

extension NCBDayFlowViewController: RSDFDatePickerViewDelegate, RSDFDatePickerViewDataSource {
    
    func datePickerView(_ view: RSDFDatePickerView, didSelect date: Date) {
        delegate?.dateDidSelect(date)
        closeBottomSheet()
    }

}
