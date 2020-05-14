//
//  NCBCalendarViewController.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/15/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit
import RSDayFlow

typealias NCBCalendarViewControllerSendDate = (String, String) -> (Void)

class NCBCalendarViewController: NCBBaseViewController {
    
    // MARK: Properties
    var ncbCalendarVCCallBack: NCBCalendarViewControllerSendDate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupCalendar()
    }
    
    func setupCalendar() {

        
        let startDate = (Calendar.current as NSCalendar).date(byAdding: .month, value: -3, to: Date(), options: [])!
        let currentDate = Date()
        
        let datePickerView = RSDFDatePickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), calendar: .autoupdatingCurrent, start: startDate, end: currentDate)
        
        
        datePickerView.delegate = self
        datePickerView.dataSource = self
        view.addSubview(datePickerView)
    }
}
extension NCBCalendarViewController {
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle("SAO KÊ TÀI KHOẢN")
    }
}

extension NCBCalendarViewController: RSDFDatePickerViewDelegate, RSDFDatePickerViewDataSource {
    func datePickerView(_ view: RSDFDatePickerView, didSelect date: Date) {
        var localDateFormatter : DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter
        }
        var localMonthFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM"
            return formatter
        }
        ncbCalendarVCCallBack!(localDateFormatter.string(from: date), localMonthFormatter.string(from: date))
        self.navigationController?.popViewController(animated: true)
    }
    func datePickerView(_ view: RSDFDatePickerView, shouldMark date: Date) -> Bool {
        let calendar = Calendar.current
        let unitFlags: Set = [Calendar.Component.year, Calendar.Component.month, Calendar.Component.day]
        let todayComponents: DateComponents = calendar.dateComponents(unitFlags, from: Date())
        let today: Date? = calendar.date(from: todayComponents)
        
        return date == today
    }
    
}
