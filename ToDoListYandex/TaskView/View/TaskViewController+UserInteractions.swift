//
//  ToDoListViewController+UserInteractions.swift
//  ToDoListYandex
//
//  Created by Анастасия Горячевская on 30.06.2023.
//

import Foundation
import CocoaLumberjackSwift

extension TaskViewController {
    @objc func tappedCancelButton() {
        DDLogInfo("Cancel button tapped")
        reloadTasksData?()
        navigationController?.dismiss(animated: true)
    }
    
    @objc func tappedSaveButton() {
        DDLogInfo("Save button tapped")
        presenter.saveTaskButtonTapped()
        reloadTasksData?()
        navigationController?.dismiss(animated: true)
    }
    
    @objc func tappedColorPickerButton() {
        DDLogInfo("Color Picker button tapped")
        presenter.colorPickerButtonTapped()
    }
    
    @objc func changedBrightnessSliderValue(_ sender: UISlider) {
        DDLogInfo("Slider value was changed")
        presenter.brightnessSliderChanged(value: Double(sender.value))
    }
    
    @objc func importanceSegmentControlValueChanged(_ sender: UISegmentedControl) {
        DDLogInfo("Importance segemnt control changed")
        presenter.importanceSegmentChangedTo(sender.selectedSegmentIndex)
    }
    
    @objc func doDueSwitchChanged(_ sender: UISwitch) {
        DDLogInfo("Deadline date switch tapped")
        _ = presenter.doDueSwitchActivated(sender.isOn)
    }
    
    @objc func doDueDateLabelTapped() {
        DDLogInfo("Deadline date tapped")
        presenter.doDueDateLabelTouched(isCalendarHidden: calendarView.isHidden)
    }
    
    @objc func deleteButtonTapped() {
        DDLogInfo("Delete button tapped")
        presenter.deleteElement()
        reloadTasksData?()
        navigationController?.dismiss(animated: true)
    }
}
