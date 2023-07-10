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
    
    func getTasks() -> [TodoItem] {
        items != [] ? items : getLocalTasks()
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
                setDirty(true)
                saveTasksLocaly([todoItem])
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
                setDirty(true)
                deleteTaskLocaly(id: id)
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
                setDirty(true)
                saveTasksLocaly([todoItem])
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
    
    private func saveTasksLocaly(_ tasks: [TodoItem]) {
        fileCache.loadAllTasksFromJSON(usingFileName: fileName)
        for task in tasks + items {
            fileCache.addNewTask(task)
        }
        fileCache.saveTasksToJSON(usingFileName: fileName)
    }
    
    private func deleteAllTasksLocaly() {
        fileCache.loadAllTasksFromJSON(usingFileName: fileName)
        fileCache.removeAllTasks()
        fileCache.saveTasksToJSON(usingFileName: fileName)
    }
    
    private func deleteTaskLocaly(id: String) {
        fileCache.loadAllTasksFromJSON(usingFileName: fileName)
        fileCache.removeTaskById(id)
        fileCache.saveTasksToJSON(usingFileName: fileName)
    }
    
    private func getLocalTasks() -> [TodoItem] {
        fileCache.loadAllTasksFromJSON(usingFileName: fileName)
        return fileCache.tasks
    }
    
    private func isDirty() -> Bool {
        defaults.bool(forKey: isDirtyKey)
    }
    
    private func setDirty(_ isDirty: Bool) {
        defaults.set(isDirty, forKey: isDirtyKey)
        if isDirty {
            saveTasksLocaly(items)
        } else {
            deleteAllTasksLocaly()
        }
    }
}
