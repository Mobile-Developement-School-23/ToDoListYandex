//
//  ToDoListViewController+UICalendarSelectionSingleDateDelegate.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 6/23/23.
//

import UIKit
import CocoaLumberjackSwift

extension TaskViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let dateComponents = dateComponents,
              let date = Calendar.current.date(from: dateComponents) else {
            fatalError("Invalid date components")
        }
        
        _ = presenter.dateChangedTo(date)
        DDLogInfo("Deadline date was chosen in calendar \(date.timeIntervalSince1970)")
    }
}
