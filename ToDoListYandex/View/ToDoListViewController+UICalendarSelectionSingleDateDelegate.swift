//
//  ToDoListViewController+UICalendarSelectionSingleDateDelegate.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 6/23/23.
//

import UIKit

extension ToDoListViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let dateComponents = dateComponents,
              let date = Calendar.current.date(from: dateComponents) else {
            fatalError("Invalid date components")
        }
        
        _ = presenter.setDeadlineDate(date)
    }
}
