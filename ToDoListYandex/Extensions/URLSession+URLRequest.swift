//
//  URLSession+URLRequest.swift
//  ToDoListYandex
//
//  Created by Анастасия Горячевская on 04.07.2023.
//

import Foundation

extension URLSession {
    func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        return try await withUnsafeThrowingContinuation { continuation in
            
            let task = self.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let responseData = data, let taskResponse = response {
                    continuation.resume(returning: (responseData, taskResponse))
                } else {
                    continuation.resume(throwing: URLError(.badServerResponse))
                }
            }
            
            if Task.isCancelled {
                task.cancel()
            } else {
                task.resume()
            }
        }
    }
}
