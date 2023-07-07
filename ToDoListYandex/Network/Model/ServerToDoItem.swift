//
//  ServerToDoItem.swift
//  ToDoListYandex
//
//  Created by Анастасия Горячевская on 07.07.2023.
//

import Foundation
import FileCache


struct ServerToDoItem: Codable {
    let id: String
    let text: String
    let importance: String
    let deadline: Int64?
    let done: Bool
    let color: String?
    let created_at: Int64
    let changed_at: Int64
    let last_updated_by: String
    
    func formToDoItem() -> TodoItem? {
        guard let creationDate = getDateFromUnixTimestamp(created_at),
              let changeDate = getDateFromUnixTimestamp(changed_at)
        else { return nil }
        
        return TodoItem(id: id,
                        text: text,
                        taskImportance: getTaskImportanceFromString(),
                        deadlineDate: getDateFromUnixTimestamp(deadline),
                        done: done,
                        creationDate: creationDate,
                        changeDate: changeDate,
                        textColor: color)
    }
    
    init(_ todoItem: TodoItem) {
        let creationDate = ServerToDoItem.getUnixTimestampFromDate(todoItem.creationDate) ?? 0
        
        self.id = todoItem.id
        self.text = todoItem.text
        self.importance = ServerToDoItem.getStringFromTaskImportance(todoItem.taskImportance)
        self.deadline = ServerToDoItem.getUnixTimestampFromDate(todoItem.deadlineDate)
        self.done = todoItem.done
        self.color = todoItem.hexColor
        self.created_at = creationDate
        self.changed_at = ServerToDoItem.getUnixTimestampFromDate(todoItem.changeDate) ?? creationDate
        self.last_updated_by = ""
    }
    
    private func getTaskImportanceFromString() -> TodoItem.TaskImportance {
        switch importance {
        case "low":
            return .unimportant
        case "important":
            return .important
        default:
            return .usual
        }
    }
    
    static private func getStringFromTaskImportance(_ taskImportance: TodoItem.TaskImportance) -> String {
        switch taskImportance {
        case .unimportant:
            return "low"
        case .usual:
            return "basic"
        case .important:
            return "important"
        }
    }
 
    private func getDateFromUnixTimestamp(_ unixTimestamp: Int64?) -> Date? {
        if let dateTime = unixTimestamp {
            return Date(timeIntervalSince1970: TimeInterval(dateTime / 1000))
        } else {
            return nil
        }
    }
    
    static private func getUnixTimestampFromDate(_ date: Date?) -> Int64? {
        guard let timeInterval = date?.timeIntervalSince1970 else {
            return nil
        }
        return Int64(timeInterval * 1000)
    }
}
