//
//  ToDoListProtocols.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 6/23/23.
//

import UIKit
import FileCache


protocol ToDoListViewControllerProtocol: AnyObject {
    
    func updateDeleteButton(setActive: Bool)
    
    func updateTaskText(_ text: NSAttributedString, isResignFirstResponder: Bool)
    
    func updateTextColor(_ color: UIColor)
    
    func updateImportanceControl(_ segment: Int)
    
    func updateDoDueDateLabelValue(_ doDueDateString: String)
    
    func displayDoDueDateLabel(_ display: Bool)
    
    func activateDoDueSwitch(_ activate: Bool)
    
    func displayCalendar(_ display: Bool)
    
    func startCalendarAnimation()
    
    func changePickerViewButtonColor(_ color: UIColor)
    
    func changeColorCodeText(_ text: String)
    
    func displayColorPickerView(_ display: Bool)
    
    func startColorPickerAnimation()
    
    func setSliderValue(_ value: Float)
}

protocol ToDoListPresenterProtocol {
    
    func fillTaskInfo(_ todoItem: TodoItem) -> Bool
    
    func textChangedTo(_ text: String)
    
    func importanceSegmentChangedTo(_ importanceSegment: Int)
    
    func dateChangedTo(_ date: Date)
    
    func doDueSwitchActivated(_ activated: Bool)
    
    func doDueDateLabelTouched(isCalendarHidden: Bool)
    
    func colorPickerButtonTapped()
    
    func brightnessSliderChanged(value: Double)
    
    func saveTaskButtonTapped()
    
    func deleteElement()
}
