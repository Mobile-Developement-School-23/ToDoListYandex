//
//  FileCache+CSV.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 6/16/23.
//

import Foundation

extension FileCache {
    func saveTasksToCSV(usingFileURL fileURL: URL) {
        let tasksCSVString = tasks.map { $0.csv }.joined(separator: "\n")
        
        do {
            try tasksCSVString.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("Error saving items to file: \(error)")
        }
    }
    
    func loadTasksFromCSV(usingFileURL fileURL: URL) {
        do {
            let csvString = try String(contentsOf: fileURL, encoding: .utf8)
            let rows = csvString.components(separatedBy: .newlines)
            
            rows.forEach {
                if let task = TodoItem.parse(csv: $0) {
                    self.addNewTask(task)
                }
            }
        } catch {
            print("Error loading items from file: \(error)")
            return
        }
    }
}
