//
//  ToDoItem.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 6/13/23.
//

import Foundation

struct TodoItem: Equatable {
    enum TaskImportance: String {
        case unimportant, usual, important
    }
    
    let id: String
    let text: String
    let taskImportance: TaskImportance
    let deadlineDate: Date?
    let done: Bool
    let creationDate: Date
    let changeDate: Date?
    
    init(id: String = UUID().uuidString,
         text: String,
         taskImportance: TaskImportance,
         deadlineDate: Date?,
         done: Bool = false,
         creationDate: Date = Date(),
         changeDate: Date?) {
        self.id = id
        self.text = text
        self.taskImportance = taskImportance
        self.deadlineDate = deadlineDate
        self.done = done
        self.creationDate = creationDate
        self.changeDate = changeDate
    }
    
}