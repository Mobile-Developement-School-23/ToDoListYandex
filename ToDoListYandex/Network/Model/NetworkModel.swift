//
//  NetworkModel.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 07.07.2023.
//

import Foundation


class NetworkModel {
    private var items: [TodoItem] = []
    
    private let networkService: NetworkingService = DefaultNetworkingService()
    
    private let fileCache = FileCache()
    private let fileName = "dirtyData"
    private let isDirtyKey = "isDirty"
    private let defaults = UserDefaults.standard
    
    init() {
        fileCache.loadAllTasksFromJSON(usingFileName: fileName)
    }
    
    func getTasks() -> [TodoItem] {
        isDirty() ? getLocalTasks() : items
    }
    
    func loadTasks(completion: (() -> Void)?) {
        updateTasksOnServerIfDirty()
        
        Task {
            do {
                if let tasks = try await networkService.getTasksList() {
                    items = tasks
                }
                setDirty(false)
            } catch {
                setDirty(true)
                items = getLocalTasks()
            }
            completion?()
        }
    }
    
    func addTask(_ todoItem: TodoItem, completion: (() -> Void)?) {
        updateTasksOnServerIfDirty()
        
        Task {
            do {
                _ = try await networkService.addTask(todoItem)
                setDirty(false)
            } catch {
                saveTaskLocaly(todoItem)
                setDirty(true)
            }
            completion?()
        }
    }
    
    func deleteTask(id: String, completion: (() -> Void)?) {
        updateTasksOnServerIfDirty()
        
        Task {
            do {
                _ = try await networkService.deleteTaskById(id)
                setDirty(false)
            } catch {
                deleteTaskLocaly(id: id)
                setDirty(true)
            }
            completion?()
        }
    }
    
    func updateTask(_ todoItem: TodoItem, completion: (() -> Void)?) {
        updateTasksOnServerIfDirty()
        
        Task {
            do {
                _ = try await networkService.updateTask(todoItem)
                setDirty(false)
            } catch {
                saveTaskLocaly(todoItem)
                setDirty(true)
            }
            completion?()
        }
    }
    
    private func replaceTasks(_ tasks: [TodoItem]) {
        Task {
            do {
                if let tasks = try await networkService.uploadTasksList(with: tasks) {
                    items = tasks
                }
                setDirty(false)
                deleteAllTasksLocaly()
            } catch {
                setDirty(true)
            }
        }
    }
    
    private func updateTasksOnServerIfDirty() {
        if isDirty() {
            let tasks = getLocalTasks()
            replaceTasks(tasks)
        }
    }
    
    private func isDirty() -> Bool {
        defaults.bool(forKey: isDirtyKey)
    }
    
    private func setDirty(_ isDirty: Bool) {
        defaults.set(isDirty, forKey: isDirtyKey)
        if isDirty {
            saveTasksLocaly(items)
        }
    }
}


extension NetworkModel {
    private func getLocalTasks() -> [TodoItem] {
        return fileCache.tasks
    }
    
    private func saveTasksLocaly(_ tasks: [TodoItem]) {
        for task in tasks + items {
            saveTaskLocaly(task)
        }
    }
    
    private func saveTaskLocaly(_ task: TodoItem) {
        fileCache.addNewTask(task)
        saveToFile()
    }
    
    private func deleteAllTasksLocaly() {
        fileCache.removeAllTasks()
        saveToFile()
    }
    
    private func deleteTaskLocaly(id: String) {
        fileCache.removeTaskById(id)
        saveToFile()
    }
    
    private func updateTaskLocaly(_ task: TodoItem) {
        fileCache.addNewTask(task)
        saveToFile()
    }
    
    private func saveToFile() {
        fileCache.saveTasksToJSON(usingFileName: fileName)
    }
}
