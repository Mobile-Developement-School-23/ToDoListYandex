//
//  ServerElements.swift
//  ToDoListYandex
//
//  Created by Анастасия Горячевская on 07.07.2023.
//

import Foundation

struct ServerElementsListRequest: Codable {
    let list: [ServerToDoItem]
}

struct ServerElementRequest: Codable {
    let element: ServerToDoItem
}

struct ServerElementsList: Codable {
    let status: String
    let list: [ServerToDoItem]
    let revision: Int
}

struct ServerElement: Codable {
    let status: String
    let element: ServerToDoItem
    let revision: Int
}
