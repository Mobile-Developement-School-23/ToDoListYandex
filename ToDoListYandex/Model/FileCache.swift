//
//  FileCache.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 6/16/23.
//

import Foundation

class FileCache {
    private(set) var tasks: [TodoItem] = []
    
    func addNewTask(_ task: TodoItem) {
        tasks.removeAll(where: { $0.id == task.id })
        tasks.append(task)
    }
    
    func removeTaskById(_ id: String) {
        tasks.removeAll(where: { $0.id == id })
    }
    
    func getTaskIndexById(_ id: String) -> Int? {
        tasks.firstIndex(where: { $0.id == id })
    }
    
    func replaceTask(_ task: TodoItem, atIndex index: Int) {
        tasks[index] = task
    }
    
    func saveTasksToJSON(usingFileName fileName: String) {
        guard let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let fileURL = documentDirectoryURL.appendingPathComponent("\(fileName).json")
        
        let tasksDictionariesArray = tasks.map { $0.json }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: tasksDictionariesArray)
            try jsonData.write(to: fileURL)
        } catch {
            print("Error saving items to file: \(error)")
        }
    }
    
    func loadAllTasksFromJSON(usingFileName fileName: String) {
        guard let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let fileURL = documentDirectoryURL.appendingPathComponent("\(fileName).json")
        
        do {
            let jsonData = try Data(contentsOf: fileURL)
            guard let tasksDictionaryArray = try JSONSerialization.jsonObject(with: jsonData) as? [[String: Any]] else {
                return
            }
            
            tasks = tasksDictionaryArray.compactMap{ TodoItem.parse(json: $0) }
        } catch {
            print("Error loading items from file: \(error)")
            return
        }
    }
}
