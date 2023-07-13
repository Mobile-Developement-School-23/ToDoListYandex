//
//  LocalCachePresenter.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 11.07.2023.
//

import Foundation

class LocalCachePresenter {
    
    private let sqliteDatabase: SQLiteProtocol = SQLiteHelper()
    
    init() {
        sqliteDatabase.loadTasksFromDB()
    }
    
    func getLocalTasks() -> [TodoItem] {
        sqliteDatabase.getTasks()
    }
    
    func saveTasksLocaly(_ tasks: [TodoItem]) {
        for task in tasks {
            saveTaskLocaly(task)
        }
    }
    
    func saveTaskLocaly(_ task: TodoItem) {
        sqliteDatabase.saveTask(task)
    }
    
    func deleteAllTasksLocaly() {
        sqliteDatabase.deleteAllTasks()
    }
    
    func deleteTaskLocaly(id: String) {
        sqliteDatabase.deleteTaskById(id)
    }
    
    func updateTaskLocaly(_ task: TodoItem) {
        sqliteDatabase.updateTask(task)
    }
}
