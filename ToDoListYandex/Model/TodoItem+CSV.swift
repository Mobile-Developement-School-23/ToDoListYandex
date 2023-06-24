//
//  TodoItem+CSV.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 6/16/23.
//

import Foundation

extension TodoItem {
    
    var csv: String {
        var dataCSV = ""
        dataCSV += "\(id);"
        dataCSV += "\(text);"
        dataCSV +=  taskImportance != .usual ? "\(taskImportance);" : ";"
        
        if let deadlineDateDouble = deadlineDate?.timeIntervalSince1970 {
            dataCSV += "\(Int(deadlineDateDouble));"
        } else {
            dataCSV += ";"
        }
        
        dataCSV += "\(String(done));"
        dataCSV += "\(Int(creationDate.timeIntervalSince1970));"
        
        if let changeDateDouble = changeDate?.timeIntervalSince1970 {
            dataCSV += "\(Int(changeDateDouble));"
        } else {
            dataCSV += ";"
        }
        
        if let color = hexColor {
            dataCSV += "\(color)"
        }
        
        return dataCSV
    }
    
    static func parse(csv: String) -> TodoItem? {
        let columns = csv.components(separatedBy: ";")
        guard columns.count == 8 else { return nil }
        
        guard (columns[0] != ""),
              (columns[1] != ""),
              (columns[2] == "" || TodoItem.TaskImportance(rawValue: columns[2]) != nil),
              (columns[3] == "" || Double(columns[3]) != nil),
              (Bool(columns[4]) != nil),
              Double(columns[5]) != nil,
              (columns[6] == "" || Double(columns[6]) != nil)
        else { return nil }
        
        let id = columns[0]
        let text = columns[1]
        let taskImportance = columns[2] != "" ?  TodoItem.TaskImportance(rawValue: columns[2])! : TaskImportance.usual
        let deadlineDate: Date? = columns[3] != "" ? Date(timeIntervalSince1970: Double(columns[3])!) : nil
        let done = Bool(columns[4])!
        let creationDate = Date(timeIntervalSince1970: Double(columns[5])!)
        let changeDate: Date? = columns[6] != "" ? Date(timeIntervalSince1970: Double(columns[6])!) : nil
        let color = columns[7] != "" ? columns[7] : nil
        
        return TodoItem(id: id,
                        text: text,
                        taskImportance: taskImportance,
                        deadlineDate: deadlineDate,
                        done: done,
                        creationDate: creationDate,
                        changeDate: changeDate,
                        textColor: color)
    }
}
