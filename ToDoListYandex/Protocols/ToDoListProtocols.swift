//
//  ToDoListProtocols.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 6/23/23.
//

import UIKit


protocol ToDoListViewControllerProtocol: AnyObject {
    
    func updateDeleteButton(setActive: Bool)
    
    func updateTaskText(_ text: String, textColor: UIColor?, isResignFirstResponder: Bool) 
    
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
    
    func loadTaskInfo()
    
    func isInfoFilled() -> Bool
    
    func setTaskText(_ text: String) -> Bool
    func setImportanceSegment(_ importanceSegment: Int) -> Bool
    func doDueSwitchActivate(_ activated: Bool) -> Bool
    func doDueDateLabelTouched(isCalendarHidden: Bool) -> Bool
    func setDeadlineDateActive(_ doDue: Bool) -> Bool
    func setDeadlineDate(_ deadline: Date?) -> Bool
    func updateTextViewSettings(_ textView: UITextView)
    
    func saveTask()
    func deleteElements()
    
    func colorPickerButtonTapped(isPickerDisplayed: Bool)
    func brightnessSliderChanged(value: Double)
}
