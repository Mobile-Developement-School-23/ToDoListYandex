//
//  NetworkPresenter.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 11.07.2023.
//

import Foundation


class NetworkPresenter {
    
    var itemsChanged: (() -> Void)?
    
    private var items: [TodoItem] = [] {
        didSet {
            itemsChanged?()
        }
    }
    
    private let networkService: NetworkingService = DefaultNetworkingService()
    
    private let localCache = LocalCachePresenter()
    
    private let isDirtyKey = "isDirty"
    private let defaults = UserDefaults.standard
    
    func getTasks() -> [TodoItem] {
        isDirty() ? localCache.getLocalTasks() : items
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
                items = localCache.getLocalTasks()
            }
            completion?()
        }
    }
    
    func addTask(_ todoItem: TodoItem, completion: (() -> Void)?) {
        updateTasksOnServerIfDirty()
        items.append(todoItem)
        
        completion?()
        
        Task {
            do {
                _ = try await networkService.addTask(todoItem)
                setDirty(false)
            } catch {
                localCache.saveTaskLocaly(todoItem)
                setDirty(true)
            }
            completion?()
        }
    }
    
    func deleteTask(id: String, completion: (() -> Void)?) {
        updateTasksOnServerIfDirty()
        items.removeAll(where: { $0.id == id })
        
        Task {
            do {
                _ = try await networkService.deleteTaskById(id)
                setDirty(false)
            } catch {
                localCache.deleteTaskLocaly(id: id)
                setDirty(true)
            }
            completion?()
        }
    }
    
    func updateTask(_ todoItem: TodoItem, completion: (() -> Void)?) {
        updateTasksOnServerIfDirty()
        items.removeAll(where: { $0.id == todoItem.id })
        items.append(todoItem)
        
        Task {
            do {
                _ = try await networkService.updateTask(todoItem)
                setDirty(false)
            } catch {
                localCache.saveTaskLocaly(todoItem)
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
                localCache.deleteAllTasksLocaly()
            } catch {
                setDirty(true)
            }
        }
    }
    
    private func updateTasksOnServerIfDirty() {
        if isDirty() {
            let tasks = localCache.getLocalTasks()
            replaceTasks(tasks)
        }
    }
    
    private func isDirty() -> Bool {
        defaults.bool(forKey: isDirtyKey)
    }
    
    private func setDirty(_ isDirty: Bool) {
        defaults.set(isDirty, forKey: isDirtyKey)
        if isDirty {
            localCache.saveTasksLocaly(items)
        }
    }
}
