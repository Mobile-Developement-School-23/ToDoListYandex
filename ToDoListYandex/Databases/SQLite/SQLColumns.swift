//
//  SQLColumns.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 13.07.2023.
//

import Foundation
import SQLite

struct Columns {
    static let id = Expression<String>(Constants.id)
    static let text = Expression<String>(Constants.text)
    static let taskImportance = Expression<String>(Constants.taskImportance)
    static let deadlineDate = Expression<Date?>(Constants.deadlineDate)
    static let done = Expression<Bool>(Constants.done)
    static let creationDate = Expression<Date>(Constants.creationDate)
    static let changeDate = Expression<Date?>(Constants.changeDate)
    static let textColor = Expression<String?>(Constants.color)
}
