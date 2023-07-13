//
//  LocalCachePresenter.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 11.07.2023.
//

import Foundation

class LocalCachePresenter {
    
    private let db: DBProtocol = CoreDataHelper()
//    private let db: DBProtocol = SQLiteHelper()
    
    init() {
        db.loadTasksFromDB()
    }
    
    func getLocalTasks() -> [TodoItem] {
        db.getTasks()
    }
    
    func saveTasksLocaly(_ tasks: [TodoItem]) {
        db.deleteAllTasks()
        for task in tasks {
            saveTaskLocaly(task)
        }
    }
    
    func saveTaskLocaly(_ task: TodoItem) {
        db.saveTask(task)
    }
    
    func deleteAllTasksLocaly() {
        db.deleteAllTasks()
    }
    
    func deleteTaskLocaly(id: String) {
        db.deleteTaskById(id)
    }
    
    func updateTaskLocaly(_ task: TodoItem) {
        db.updateTask(task)
    }
}
