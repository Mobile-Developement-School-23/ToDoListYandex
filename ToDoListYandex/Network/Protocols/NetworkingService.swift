//
//  Protocols.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 05.07.2023.
//

import Foundation
import FileCache

protocol NetworkingService {
    
    func getTasksList() async throws -> [TodoItem]?
    
    func uploadTasksList(with items: [TodoItem]) async throws -> [TodoItem]?
    
    func getTaskById(_ id: String) async throws -> TodoItem?
    
    func addTask(_ task: TodoItem) async throws -> TodoItem?
    
    func updateTask(_ task: TodoItem) async throws -> TodoItem?
    
    func deleteTaskById(_ id: String) async throws -> TodoItem?
}
