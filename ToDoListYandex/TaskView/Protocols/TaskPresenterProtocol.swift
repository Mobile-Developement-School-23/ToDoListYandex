//
//  ToDoListProtocols.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 6/23/23.
//

import UIKit
import FileCache


protocol TaskPresenterProtocol {
    
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
