//
//  SQLiteProtocol.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 13.07.2023.
//

import Foundation

protocol SQLiteProtocol {
    
    func getTasks() -> [TodoItem]
    
    func loadTasksFromDB()
    
    func saveTask(_ todoItem: TodoItem)
    
    func deleteTaskById(_ id: String)
    
    func updateTask(_ todoItem: TodoItem)
    
    func deleteAllTasks()
}
