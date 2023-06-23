//
//  ToDoListViewPresenter.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 6/21/23.
//

import UIKit


class ToDoListPresenter: ToDoListPresenterProtocol, ColorPickerDelegate {
    
    var taskText: String = ""
    var importance: TodoItem.TaskImportance = .important
    var doDueActivated: Bool = false
    var doDue: Date? = nil
    var brightTextColor: UIColor = .labelPrimary
    var taskTextColor: UIColor = .labelPrimary
    
    weak var view: ToDoListViewControllerProtocol!
    
    private let fileName = "newTaskFileName"
    
    private let importanceIndex: [TodoItem.TaskImportance] = [.unimportant, .usual, .important]
    
    func loadTaskInfo() {
        let fileCache = FileCache()
        fileCache.loadAllTasksFromJSON(usingFileName: fileName)
        
        guard let toDoItem = fileCache.tasks.first else { return }
        
        if let color = toDoItem.hexColor {
            brightTextColor = UIColor(hex: color) ?? .labelPrimary
            taskTextColor = UIColor(hex: color) ?? .labelPrimary
            view.changeColorCodeText(color)
            view.changePickerViewButtonColor(taskTextColor)
        }
        view.updateTaskText(toDoItem.text, textColor: taskTextColor, isResignFirstResponder: false)
        _ = setImportanceSegment(importanceIndex.firstIndex(of: toDoItem.taskImportance) ?? 2)
        view.activateDoDueSwitch(toDoItem.deadlineDate != nil)
        _ = setDeadlineDate(toDoItem.deadlineDate)
    }
    
    func isInfoFilled() -> Bool {
        return taskText != ""
    }
    
    func setTaskText(_ text: String) -> Bool {
        self.taskText = text
        view.updateDeleteButton(setActive: text != "")
        return true
    }
    
    func setImportanceSegment(_ importanceSegment: Int) -> Bool {
        self.importance = importanceIndex[importanceSegment]
        view.updateImportanceControl(importanceSegment)
        return true
    }
    
    func doDueSwitchActivate(_ activated: Bool) -> Bool {
        _ = setDeadlineDateActive(activated)
        view.displayDoDueDateLabel(activated)
        if !activated {
            _ = doDueDateLabelTouched(isCalendarHidden: false)
        }
        return true
    }
    
    func setDeadlineDateActive(_ doDue: Bool) -> Bool {
        if doDue {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMMM yyyy"
            let date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
            
            _ = setDeadlineDate(date)
        } else {
            _ = setDeadlineDate(nil)
        }
        
        self.doDueActivated = doDue
        return true
    }
    
    func doDueDateLabelTouched(isCalendarHidden: Bool) -> Bool {
        view.displayCalendar(isCalendarHidden)
        if isCalendarHidden {
            view.startCalendarAnimation()
        }
        return true
    }
    
    func setDeadlineDate(_ deadline: Date?) -> Bool {
        if let deadline = deadline {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMMM yyyy"
            
            let dateString = dateFormatter.string(from: deadline)
            view.displayDoDueDateLabel(true)
            view.updateDoDueDateLabelValue(dateString)
        } else {
            view.displayDoDueDateLabel(false)
        }
        
        self.doDue = deadline
        return true
    }
    
    func updateTextViewSettings(_ textView: UITextView) {
        if textView.textColor == .labelTertiary {
            removePlaceholderTextView()
        } else if textView.text.isEmpty {
            setPlaceholderTextView()
        } else {
            _ = setTaskText(textView.text)
        }
    }
    
    func removePlaceholderTextView() {
        view.updateTaskText("", textColor: taskTextColor, isResignFirstResponder: false)
        _ = setTaskText("")
    }
    
    func setPlaceholderTextView() {
        view.updateTaskText("Что надо сделать?", textColor: .labelTertiary, isResignFirstResponder: true)
        _ = setTaskText("")
    }
    
    func saveTask() {
        guard isInfoFilled() else { return }
        
        let todoItem = TodoItem(text: taskText,
                                taskImportance: importance,
                                deadlineDate: doDue,
                                creationDate: Date(),
                                changeDate: nil,
                                textColor: taskTextColor.getColorCode())
        
        let fileCache = FileCache()
        fileCache.addNewTask(todoItem)
        
        fileCache.saveTasksToJSON(usingFileName: fileName)
    }
    
    func deleteElements() {
        setPlaceholderTextView()
        _ = setImportanceSegment(2)
        _ = doDueDateLabelTouched(isCalendarHidden: false)
        _ = setDeadlineDateActive(false)
        view.activateDoDueSwitch(false)
    }
    
    func colorPickerButtonTapped(isPickerDisplayed: Bool) {
        view.displayColorPickerView(!isPickerDisplayed)
        if !isPickerDisplayed {
            view.startColorPickerAnimation()
        }
    }
    
    func colorPickerTouched(color: UIColor) {
        if taskText != "" {
            view.updateTaskText(taskText, textColor: color, isResignFirstResponder: false)
        }
        view.changePickerViewButtonColor(color)
        view.changeColorCodeText(taskTextColor.getColorCode())
        taskTextColor = color
        brightTextColor = color
        view.setSliderValue(1)
    }
    
    func brightnessSliderChanged(value: Double) {
        taskTextColor = brightTextColor.setBrightness(brightness: value)
        view.changePickerViewButtonColor(taskTextColor)
        view.changeColorCodeText(taskTextColor.getColorCode())
        
        if taskText != "" {
            view.updateTaskText(taskText, textColor: taskTextColor, isResignFirstResponder: false)
        }
    }
}
