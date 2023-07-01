//
//  TodoItemTests.swift
//  ToDoListYandexTests
//
//  Created by Anastasia Sharapenko on 6/15/23.
//

import XCTest
import Foundation
@testable import ToDoListYandex

final class TodoItemTests: XCTestCase {
    
    func testTodoItemCreationWithAllParameters() throws {
        let uuid = UUID().uuidString
        let todoItem = TodoItem(id: uuid,
                                text: "Develop an app",
                                taskImportance: TodoItem.TaskImportance.important,
                                deadlineDate: Date(timeIntervalSince1970: 1655700000),
                                done: false,
                                creationDate: Date(timeIntervalSince1970: 1654000000),
                                changeDate: Date(timeIntervalSince1970: 1655000000))
        
        XCTAssert(todoItem.id == uuid)
        XCTAssert(todoItem.text == "Develop an app")
        XCTAssert(todoItem.taskImportance == TodoItem.TaskImportance.important)
        XCTAssert(todoItem.deadlineDate == Date(timeIntervalSince1970: 1655700000))
        XCTAssert(todoItem.done == false)
        XCTAssert(todoItem.creationDate == Date(timeIntervalSince1970: 1654000000))
        XCTAssert(todoItem.changeDate == Date(timeIntervalSince1970: 1655000000))
    }
    
    func testTodoItemCreationWithMinimumParameters() throws {
        let todoItem = TodoItem(text: "Learn English in 2 days",
                                taskImportance: TodoItem.TaskImportance.usual,
                                deadlineDate: nil,
                                changeDate: nil)
        
        XCTAssert(UUID(uuidString: todoItem.id) != nil)
        XCTAssert(todoItem.text == "Learn English in 2 days")
        XCTAssert(todoItem.taskImportance == TodoItem.TaskImportance.usual)
        XCTAssert(todoItem.deadlineDate == nil)
        XCTAssert(todoItem.done == false)
        XCTAssert(abs(todoItem.creationDate.timeIntervalSinceNow) < 60)
        XCTAssert(todoItem.changeDate == nil)
    }
}
