//
//  LocalCachePresenter.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 11.07.2023.
//

import Foundation

class LocalCachePresenter {
    
    private let fileCache = FileCache()
    private let fileName = "dirtyData"
    
    init() {
        fileCache.loadAllTasksFromJSON(usingFileName: fileName)
    }
    
    func getLocalTasks() -> [TodoItem] {
        return fileCache.tasks
    }
    
    func saveTasksLocaly(_ tasks: [TodoItem]) {
        for task in tasks {
            saveTaskLocaly(task)
        }
    }
    
    func saveTaskLocaly(_ task: TodoItem) {
        fileCache.addNewTask(task)
        saveToFile()
    }
    
    func deleteAllTasksLocaly() {
        fileCache.removeAllTasks()
        saveToFile()
    }
    
    func deleteTaskLocaly(id: String) {
        fileCache.removeTaskById(id)
        saveToFile()
    }
    
    func updateTaskLocaly(_ task: TodoItem) {
        fileCache.addNewTask(task)
        saveToFile()
    }
    
    func saveToFile() {
        fileCache.saveTasksToJSON(usingFileName: fileName)
    }
}
