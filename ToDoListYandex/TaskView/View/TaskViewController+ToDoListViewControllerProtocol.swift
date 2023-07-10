//
//  ToDoListViewController+ToDoListViewControllerProtocol.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 30.06.2023.
//

import UIKit
import CocoaLumberjackSwift

extension TaskViewController: TaskViewControllerProtocol {
    func activateDoDueSwitch(_ activate: Bool) {
        doDueSwitch.isOn = activate
        DDLogInfo("Deadline date switch activated")
    }
    
    func displayCalendar(_ display: Bool) {
        divider2.isHidden = !display
        calendarView.isHidden = !display
        DDLogInfo(display ? "Calendar displayed": "Calendar hidden")
    }
    
    func startCalendarAnimation() {
        calendarView.alpha = 0.0
        UIView.animate(withDuration: 0.3) {
            self.calendarView.alpha = 1.0
            self.calendarView.transform = .identity
        }
    }
    
    func updateTaskText(_ text: NSAttributedString, isResignFirstResponder: Bool) {
        let font = taskTextView.font
        taskTextView.attributedText = text
        taskTextView.font = font
        if isResignFirstResponder {
            taskTextView.resignFirstResponder()
        }
        recalculateTextViewHeight(taskTextView)
    }
    
    func updateTextColor(_ color: UIColor) {
        taskTextView.textColor = color
    }
    
    func updateImportanceControl(_ segment: Int) {
        importanceSegmentControl.selectedSegmentIndex = segment
        DDLogInfo("Importance control value was changed to \(segment)")
    }
    
    func displayDoDueDateLabel(_ display: Bool) {
        doDueDateLabel.isHidden = !display
        DDLogInfo(display ? "Deadline date label displayed" : "Deadline date label hidden")
    }
    
    func updateDeleteButton(setActive: Bool) {
        deleteButton.isEnabled = setActive
    }
    
    func updateDoDueDateLabelValue(_ doDueDateString: String) {
        doDueDateLabel.text = doDueDateString
        DDLogInfo("Deadline date Label value changed to \(doDueDateString)")
    }
    
    func changePickerViewButtonColor(_ color: UIColor) {
        colorButton.backgroundColor = color
        DDLogInfo("Color Picker button color changed to \(color.getColorCode())")
    }
    
    func changeColorCodeText(_ text: String) {
        colorLabel.text = text
        DDLogInfo("Color code text changed to \(text)")
    }
    
    func displayColorPickerView(_ display: Bool) {
        colorPickerView.isHidden = !display
        brightnessSliderView.isHidden = !display
        DDLogInfo(display ? "Color picker hidden" : "Color picker displayed")
    }
    
    func startColorPickerAnimation() {
        colorPickerView.alpha = 0.0
        UIView.animate(withDuration: 0.3) {
            self.colorPickerView.alpha = 1.0
            self.colorPickerView.transform = .identity
        }
    }
    
    func setSliderValue(_ value: Float) {
        brightnessSliderView.value = value
        DDLogInfo("Slider Value changed to \(value)")
    }
}
