//
//  ToDoListViewPresenter.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 6/21/23.
//

import UIKit
import FileCache


class TaskPresenter: TaskPresenterProtocol, ColorPickerDelegate {
    
    private var originalTodoItem: TodoItem?
    
    private var id: String = ""
    private var taskText: String = ""
    private var importance: TodoItem.TaskImportance = .usual
    private var doDueActivated: Bool = false
    private var deadline: Date?
    
    private var brightTextColor: UIColor = .labelPrimary
    private var taskTextColor: UIColor = .labelPrimary
    private var placeholderColor: UIColor = .labelTertiary
    
    private var isPickerDisplayed: Bool = false
    
    weak var view: TaskViewControllerProtocol!
    
    private let fileName = "newTaskFileName"
    
    private let importanceIndex: [TodoItem.TaskImportance] = [.unimportant, .usual, .important]
    
    func fillTaskInfo(_ todoItem: TodoItem) -> Bool {
        id = todoItem.id
        setTaskText(todoItem.text)
        setImportance(todoItem.taskImportance)
        setTextColor(UIColor(hex: todoItem.hexColor ?? "") ?? .labelPrimary)
        setDeadlineDate(todoItem.deadlineDate)
        originalTodoItem = todoItem
        
        return true
    }
    
    func isInfoFilled() -> Bool {
        return taskText != ""
    }
    
    private func setTaskText(_ text: String?) {
        self.taskText = text != nil ? text! : ""
        if text == nil {
            setPlaceholderTextView()
        } else {
            setTextTextView()
        }
        view.updateDeleteButton(setActive: text != "")
    }
    
    private func setTextTextView() {
        view.updateTaskText(NSAttributedString(string: taskText), isResignFirstResponder: false)
        view.updateTextColor(taskTextColor)
    }
    
    private func setPlaceholderTextView() {
        view.updateTaskText(NSAttributedString(string: "Что надо сделать?"), isResignFirstResponder: true)
        view.updateTextColor(placeholderColor)
    }
    
    private func setImportance(_ importance: TodoItem.TaskImportance) {
        self.importance = importance
        view.updateImportanceControl(importanceIndex.firstIndex(of: importance) ?? 1)
    }
    
    private func setTextColor(_ color: UIColor) {
        self.taskTextColor = color
        view.updateTextColor(taskTextColor)
        view.changePickerViewButtonColor(taskTextColor)
        view.changeColorCodeText(taskTextColor.getColorCode())
    }
    
    private func setDeadlineDate(_ deadline: Date?) {
        if let deadline = deadline {
            let dateString = deadline.dayMonthYearDate
            view.displayDoDueDateLabel(true)
            view.updateDoDueDateLabelValue(dateString)
            view.activateDoDueSwitch(true)
        } else {
            view.displayDoDueDateLabel(false)
            view.activateDoDueSwitch(false)
        }
        
        self.deadline = deadline
    }
    
    func textChangedTo(_ text: String) {
        switch text {
        case "":
            setTaskText(nil)
        case "Что надо сделать?":
            setTaskText("")
        default:
            setTaskText(text)
        }
    }
    
    func importanceSegmentChangedTo(_ importanceSegment: Int) {
        self.importance = importanceIndex[importanceSegment]
        view.updateImportanceControl(importanceSegment)
    }
    
    func dateChangedTo(_ date: Date) {
        setDeadlineDate(date)
    }
    
    func doDueSwitchActivated(_ activated: Bool) {
        if activated {
            setTomorrowDeadline()
        }
        view.displayDoDueDateLabel(activated)
    }
    
    func doDueDateLabelTouched(isCalendarHidden: Bool) {
        displayCalendar(isCalendarHidden)
    }
    
    private func displayCalendar(_ display: Bool) {
        view.displayCalendar(display)
        if display {
            view.startCalendarAnimation()
        }
    }
    
    func setTomorrowDeadline() {
        let date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        setDeadlineDate(date)
    }
    
    func colorPickerButtonTapped() {
        isPickerDisplayed = !isPickerDisplayed
        view.displayColorPickerView(isPickerDisplayed)
        if isPickerDisplayed {
            view.startColorPickerAnimation()
        }
    }
    
    func colorPickerTouched(color: UIColor) {
        if taskText != "" {
            view.updateTextColor(color)
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
            view.updateTextColor(taskTextColor)
        }
    }
    
    func saveTaskButtonTapped() -> (TodoItem, Bool)? {
        saveTask()
    }
    
    private func saveTask() -> (TodoItem, Bool)? {
        guard isInfoFilled() else { return nil }
        
        var id: String = UUID().uuidString
        var done: Bool = false
        var changeDate: Date?
        var creationDate: Date = Date()
        if let originalTodoItem = originalTodoItem {
            done = originalTodoItem.done
            changeDate = originalTodoItem.changeDate
            id = originalTodoItem.id
            creationDate = originalTodoItem.creationDate
        }
        
        let todoItem = TodoItem(id: id,
                                text: taskText,
                                taskImportance: importance,
                                deadlineDate: deadline,
                                done: done,
                                creationDate: creationDate,
                                changeDate: changeDate,
                                textColor: taskTextColor.getColorCode())
        
        return (todoItem, self.id == "")
    }
    

    func deleteElement() -> String? {
        id != "" ? id : nil
    }
}
