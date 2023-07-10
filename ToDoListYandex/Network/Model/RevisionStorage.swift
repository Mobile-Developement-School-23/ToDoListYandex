//
//  RevisionStorage.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 07.07.2023.
//

import Foundation

actor RevisionStorage {
    private var revision: Int = 13

    func getRevision() -> Int {
        return revision
    }

    func updateRevision(_ newRevision: Int) {
        revision = newRevision
    }
}
