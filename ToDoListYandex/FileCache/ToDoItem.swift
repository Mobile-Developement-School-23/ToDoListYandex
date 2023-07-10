//
//  ToDoItem.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 10.07.2023.
//
import Foundation


public struct TodoItem: Equatable {
    public enum TaskImportance: String {
        case unimportant, usual, important
    }
    
    public let id: String
    public let text: String
    public let taskImportance: TaskImportance
    public let deadlineDate: Date?
    public let done: Bool
    public let creationDate: Date
    public let changeDate: Date?
    public let hexColor: String?
    
    public init(id: String = UUID().uuidString,
                text: String,
                taskImportance: TaskImportance,
                deadlineDate: Date? = nil,
                done: Bool = false,
                creationDate: Date = Date(),
                changeDate: Date? = nil,
                textColor: String? = nil) {
        self.id = id
        self.text = text
        self.taskImportance = taskImportance
        self.deadlineDate = deadlineDate
        self.done = done
        self.creationDate = creationDate
        self.changeDate = changeDate
        self.hexColor = textColor
    }
    
}
