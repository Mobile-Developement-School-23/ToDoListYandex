//
//  CheckRequest.swift
//  ToDoListYandex
//
//  Created by Анастасия Горячевская on 04.07.2023.
//

import Foundation

struct CheckRequest {
    let urlStrings = ["https://random-data-api.com/api/v2/users?size=10",
                      "https://random-data-api.com/api/v2/banks?size=15",
                      "https://random-data-api.com/api/v2/credit_cards?size=8",
                      "https://random-data-api.com/api/v2/addresses?size=2"]
    
    let urlSession = URLSession.shared
    
    init() {
        for (num, urlString) in urlStrings.enumerated() {
            guard let url = URL(string: urlString) else { return }
            runTask(url: url, taskNum: num + 1)
        }
    }
    
    func runTask(url: URL, taskNum: Int) {
        let urlRequest = URLRequest(url: url)
        
        let taskConcurrent = Task {
            let task = try await urlSession.dataTask(for: urlRequest)
            
            let json = try JSONSerialization.jsonObject(with: task.0)
            print("\(taskNum): ", task.0)
        }
        
        if taskNum == 2 {
            taskConcurrent.cancel()
        }
    }
}
