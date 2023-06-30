//
//  FileCache.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 6/16/23.
//

import Foundation
import CocoaLumberjackSwift

class FileCache {
    private(set) var tasks: [TodoItem] = []
    
    func addNewTask(_ task: TodoItem) {
        tasks.removeAll(where: { $0.id == task.id })
        tasks.append(task)
        DDLogInfo("New task was added. Id: \(task.id)")
    }
    
    func removeTaskById(_ id: String) {
        tasks.removeAll(where: { $0.id == id })
        DDLogInfo("Task deleted. Id: \(id)")
    }
    
    func getTaskIndexById(_ id: String) -> Int? {
        tasks.firstIndex(where: { $0.id == id })
    }
    
    func replaceTask(_ task: TodoItem, atIndex index: Int) {
        tasks[index] = task
        DDLogInfo("Task replaced. Id: \(task.id)")
    }
    
    func saveTasksToJSON(usingFileName fileName: String) {
        DDLogInfo("Start saving tasks to JSON with file: \(fileName)")
        guard let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory,
                                                                  in: .userDomainMask).first else {
            DDLogError("Error getting documentDirectory url")
            return
        }
        let fileURL = documentDirectoryURL.appendingPathComponent("\(fileName).json")
        
        let tasksDictionariesArray = tasks.map { $0.json }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: tasksDictionariesArray)
            try jsonData.write(to: fileURL)
            DDLogInfo("Tasks saved to file: \(fileName)")
        } catch {
            DDLogError("Error saving items to file: \(fileName) with error: \(error)")
            return
        }
    }
    
    func loadAllTasksFromJSON(usingFileName fileName: String) {
        DDLogInfo("Start loading tasks from JSON with file: \(fileName)")
        guard let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory,
                                                                  in: .userDomainMask).first else {
            DDLogError("Error getting documentDirectory url")
            return
        }
        let fileURL = documentDirectoryURL.appendingPathComponent("\(fileName).json")
        
        do {
            let jsonData = try Data(contentsOf: fileURL)
            guard let tasksDictionaryArray = try JSONSerialization.jsonObject(with: jsonData) as? [[String: Any]] else {
                return
            }
            
            tasks = tasksDictionaryArray.compactMap { TodoItem.parse(json: $0) }
            
            DDLogInfo("Tasks load from file: \(fileName)")
        } catch {
            DDLogError("Error loading items from file: \(fileName) with error: \(error)")
            return
        }
    }
}
