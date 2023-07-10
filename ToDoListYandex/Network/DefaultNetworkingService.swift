//
//  DefaultNetworkingService.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 05.07.2023.
//

import Foundation
import FileCache


enum NetworkError: Error {
    case requestCreationError
    case requestExecutionError
}

class DefaultNetworkingService: NetworkingService {

    private let baseURL = "https://beta.mrdekk.ru/todobackend"
    private let authorizationToken = "conceity"
    private let urlSession = URLSession(configuration: .default)
    
    private let revisionStorage = RevisionStorage()
    
    func getTasksList() async throws -> [TodoItem]? {
        guard let request = await createRequest(path: baseURL + "/list", method: "GET") else {
            throw NetworkError.requestCreationError
        }
        
        return try await makeRequest(request)
    }

    
    func uploadTasksList(with items: [TodoItem]) async throws -> [TodoItem]? {
        let serverItems = ServerElementsListRequest(list: items.compactMap { ServerToDoItem($0) })
        
        guard let data = try? JSONEncoder().encode(serverItems),
              let request = await createRequest(path: baseURL + "/list",
                                                method: "PATCH",
                                                body: data,
                                                withRevision: true) else {
            throw NetworkError.requestCreationError
        }
        
        return try await makeRequest(request)
    }
    
    func getTaskById(_ id: String) async throws -> TodoItem? {
        guard let request = await createRequest(path: baseURL + "/list/\(id)", method: "GET")  else {
            throw NetworkError.requestCreationError
        }
        
        return try await makeRequestForOneElement(request)
    }
    
    func addTask(_ task: TodoItem) async throws -> TodoItem? {
        let serverItem = ServerElementRequest(element: ServerToDoItem(task))
        
        guard let data = try? JSONEncoder().encode(serverItem),
              let request = await createRequest(path: baseURL + "/list",
                                                method: "POST",
                                                body: data,
                                                withRevision: true)  else {
            throw NetworkError.requestCreationError
        }
        
        return try await makeRequestForOneElement(request)
    }
    
    func updateTask(_ task: TodoItem) async throws -> TodoItem? {
        let id = task.id
        let serverItem = ServerElementRequest(element: ServerToDoItem(task))
        
        guard let data = try? JSONEncoder().encode(serverItem),
              let request = await createRequest(path: baseURL + "/list/\(id)",
                                                method: "PUT",
                                                body: data,
                                                withRevision: true)  else {
            throw NetworkError.requestCreationError
        }
        
        return try await makeRequestForOneElement(request)
    }
    
    
    func deleteTaskById(_ id: String) async throws -> TodoItem? {
        guard let request = await createRequest(path: baseURL + "/list/\(id)",
                                                method: "DELETE",
                                                withRevision: true)  else {
            throw NetworkError.requestCreationError
        }
        
        return try await makeRequestForOneElement(request)
    }
    
    private func createRequest(path: String,
                               method: String,
                               body: Data? = nil,
                               withRevision: Bool = false) async -> URLRequest? {
        
        guard let url = URL(string: path) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Bearer \(authorizationToken)", forHTTPHeaderField: "Authorization")
        request.httpBody = body
        
        if withRevision {
            let revision = await revisionStorage.getRevision()
            request.setValue("\(revision)", forHTTPHeaderField: "X-Last-Known-Revision")
        }
        
        return request
    }
    
    private func makeRequest(_ request: URLRequest) async throws -> [TodoItem]? {
        do {
            let (data, _) = try await urlSession.dataTask(for: request)
            let items = try? JSONDecoder().decode(ServerElementsList.self, from: data)
            let serverToDoItems = items?.list
            
            await revisionStorage.updateRevision(Int(items?.revision ?? 0))
            return serverToDoItems?.compactMap { $0.formToDoItem() }
        } catch {
            throw NetworkError.requestExecutionError
        }
    }
    
    private func makeRequestForOneElement(_ request: URLRequest) async throws -> TodoItem? {
        do {
            let (data, _) = try await urlSession.dataTask(for: request)
            let items = try? JSONDecoder().decode(ServerElement.self, from: data)
            let serverToDoItem = items?.element
            
            await revisionStorage.updateRevision(Int(items?.revision ?? 0))
            return serverToDoItem?.formToDoItem()
        } catch {
            throw NetworkError.requestExecutionError
        }
    }
    
}
