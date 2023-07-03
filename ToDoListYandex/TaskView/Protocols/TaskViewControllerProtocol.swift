//
//  TaskViewControllerProtocol.swift
//  ToDoListYandex
//
//  Created by Анастасия Горячевская on 03.07.2023.
//

import UIKit

protocol TaskViewControllerProtocol: AnyObject {
    
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
