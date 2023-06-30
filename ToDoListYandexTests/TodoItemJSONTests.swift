//
//  TodoItemJSONTests.swift
//  ToDoListYandexTests
//
//  Created by Anastasia Sharapenko on 6/15/23.
//

import XCTest
import Foundation
@testable import ToDoListYandex

final class TodoItemJSONTests: XCTestCase {

    func testFormingJSONWithAllParameters() throws {
        let uuid = UUID().uuidString
        let todoItem = TodoItem(id: uuid,
                                text: "Make an appointment to a doctor",
                                taskImportance: TodoItem.TaskImportance.important,
                                deadlineDate: Date(timeIntervalSince1970: 1686000000),
                                done: true,
                                creationDate: Date(timeIntervalSince1970: 1684300000),
                                changeDate: Date(timeIntervalSince1970: 1684600000))
        
        guard let data = todoItem.json as? [String: Any] else {
            XCTFail("Failed to get correct data type")
            return
        }
        
        XCTAssertNotNil(data)
        XCTAssertEqual(data[Constants.id] as? String, uuid)
        XCTAssertEqual(data[Constants.text] as? String, "Make an appointment to a doctor")
        XCTAssertEqual(data[Constants.taskImportance] as? String, "important")
        XCTAssertEqual(data[Constants.deadlineDate] as? TimeInterval, 1686000000)
        XCTAssertEqual(data[Constants.done] as? Bool, true)
        XCTAssertEqual(data[Constants.creationDate] as? TimeInterval, 1684300000)
        XCTAssertEqual(data[Constants.changeDate] as? TimeInterval, 1684600000)
    }
    
    func testFormingJSONWithMinimumParameters() throws {
        let todoItem = TodoItem(text: "Write tasks to Todo list",
                                taskImportance: TodoItem.TaskImportance.usual,
                                deadlineDate: nil,
                                changeDate: nil)
        
        guard let data = todoItem.json as? [String: Any] else {
            XCTFail("Failed to get correct data type")
            return
        }
        
        XCTAssertNotNil(data)
        XCTAssertNotNil(data[Constants.id] as? String)
        XCTAssertEqual(data[Constants.text] as? String, "Write tasks to Todo list")
        XCTAssertNil(data[Constants.taskImportance])
        XCTAssertNil(data[Constants.deadlineDate])
        XCTAssertEqual(data[Constants.done] as? Bool, false)
        XCTAssertNotNil(data[Constants.creationDate] as? TimeInterval)
        
        guard let creationDateTimeInterval = data[Constants.creationDate] as? TimeInterval else {
            XCTFail("Error getting correct type of task creation date")
        }
        let creationDate = Date(timeIntervalSince1970: creationDateTimeInterval)
        XCTAssert(abs(creationDate.timeIntervalSinceNow) < 60)
        XCTAssertNil(data[Constants.changeDate])
    }
    
    func testInputJSONIncorectType() throws {
        let todoItem = TodoItem.parse(json: "Some task")
        XCTAssertNil(todoItem)
    }
    
    func testInputJSONIncorectDictType() throws {
        let tasks: [String: String] = ["id": "ADA4E7CB-F766-417A-9626-A278A1B0BA2C",
                                       "text": "Kiss wife",
                                       "done": "true"]
        let todoItem = TodoItem.parse(json: tasks)
        XCTAssertNil(todoItem)
    }
    
    func testParsingEmptyJSON() throws {
        let jsonDict: [String: Any] = [:]
        
        let todoItem = TodoItem.parse(json: jsonDict)
        XCTAssertNil(todoItem)
    }

    func testParsingJSONWithAllParameters() throws {
        let jsonDict: [String: Any] = [Constants.id: "ADA4E7CB-F766-417A-9626-A278A1B0BA2C",
                                       Constants.text: "Walking a dog",
                                       Constants.taskImportance: "unimportant",
                                       Constants.deadlineDate: 1686000000.0,
                                       Constants.done: true,
                                       Constants.creationDate: 1684300000.0,
                                       Constants.changeDate: 1684600000.0]
        
        let todoItem = TodoItem.parse(json: jsonDict)
        
        XCTAssertEqual(todoItem?.id, "ADA4E7CB-F766-417A-9626-A278A1B0BA2C")
        XCTAssertEqual(todoItem?.text, "Walking a dog")
        XCTAssertEqual(todoItem?.taskImportance, TodoItem.TaskImportance.unimportant)
        XCTAssertEqual(todoItem?.deadlineDate, Date(timeIntervalSince1970: 1686000000))
        XCTAssertEqual(todoItem?.done, true)
        XCTAssertEqual(todoItem?.creationDate, Date(timeIntervalSince1970: 1684300000))
        XCTAssertEqual(todoItem?.changeDate, Date(timeIntervalSince1970: 1684600000))
    }
    
    func testParsingJSONWithMinimumParameters() throws {
        let jsonDict: [String: Any] = [Constants.id: "9B891A5A-DAA0-4FB1-9955-48254AE3DABD",
                                       Constants.text: "Save the princess",
                                       Constants.done: false,
                                       Constants.creationDate: 1684300000.0]
        
        let todoItem = TodoItem.parse(json: jsonDict)
        
        XCTAssertEqual(todoItem?.id, "9B891A5A-DAA0-4FB1-9955-48254AE3DABD")
        XCTAssertEqual(todoItem?.text, "Save the princess")
        XCTAssertEqual(todoItem?.taskImportance, TodoItem.TaskImportance.usual)
        XCTAssertNil(todoItem?.deadlineDate)
        XCTAssertEqual(todoItem?.done, false)
        XCTAssertEqual(todoItem?.creationDate, Date(timeIntervalSince1970: 1684300000))
        XCTAssertNil(todoItem?.changeDate)
    }
    
    func testParsingJSONWithIncorrectIdType() throws {
        let jsonDict: [String: Any] = [Constants.id: 18344,
                                       Constants.text: "Default task",
                                       Constants.done: false,
                                       Constants.creationDate: 1684400000.0]
        
        let todoItem = TodoItem.parse(json: jsonDict)
        XCTAssertNil(todoItem)
    }
    
    func testParsingJSONWithoutId() throws {
        let jsonDict: [String: Any] = [Constants.text: "Buy flowers",
                                       Constants.done: false,
                                       Constants.creationDate: 1684400000.0]
        
        let todoItem = TodoItem.parse(json: jsonDict)
        XCTAssertNil(todoItem)
    }
    
    func testParsingJSONWithIncorrectTextFieldType() throws {
        let jsonDict: [String: Any] = [Constants.id: "9B891A5A-DAA0-4FB1-9955-48254AE3DABD",
                                       Constants.text: 15622,
                                       Constants.done: false,
                                       Constants.creationDate: 1684400000.0]
        
        
        let todoItem = TodoItem.parse(json: jsonDict)
        XCTAssertNil(todoItem)
    }
    
    func testParsingJSONWithoutTextField() throws {
        let jsonDict: [String: Any] = [Constants.id: "9B891A5A-DAA0-4FB1-9955-48254AE3DABD",
                                       Constants.done: false,
                                       Constants.creationDate: 1684400000.0]
        
        let todoItem = TodoItem.parse(json: jsonDict)
        XCTAssertNil(todoItem)
    }
    
    func testParsingJSONWithIncorrectDoneFieldType() throws {
        let jsonDict: [String: Any] = [Constants.id: "9B891A5A-DAA0-4FB1-9955-48254AE3DABD",
                                       Constants.text: "Create unit test",
                                       Constants.done: 1422,
                                       Constants.creationDate: 1684400000.0]
        
        let todoItem = TodoItem.parse(json: jsonDict)
        XCTAssertNil(todoItem)
    }
    
    func testParsingJSONWithIncorrectCreationTimeFieldType() throws {
        let jsonDict: [String: Any] = [Constants.id: "9B891A5A-DAA0-4FB1-9955-48254AE3DABD",
                                       Constants.text: "Find error in code",
                                       Constants.done: true,
                                       Constants.creationDate: "May 2"]
        
        let todoItem = TodoItem.parse(json: jsonDict)
        XCTAssertNil(todoItem)
    }
    
    func testParsingJSONWithoutCreationDateField() throws {
        let jsonDict: [String: Any] = [Constants.id: "9B891A5A-DAA0-4FB1-9955-48254AE3DABD",
                                       Constants.text: "Save money",
                                       Constants.done: false]
        
        let todoItem = TodoItem.parse(json: jsonDict)
        XCTAssertNil(todoItem)
    }
    
    func testParsingJSONWithIncorrectTaskImportanceField() throws {
        let jsonDict: [String: Any] = [Constants.id: "9B891A5A-DAA0-4FB1-9955-48254AE3DABD",
                                       Constants.text: "Wash hands",
                                       Constants.taskImportance: "backlog",
                                       Constants.done: true,
                                       Constants.creationDate: 1684400000.0]
        
        let todoItem = TodoItem.parse(json: jsonDict)
        XCTAssertNil(todoItem)
    }
    
    func testParsingJSONWithIncorrectDeadlineDateFieldType() throws {
        let jsonDict: [String: Any] = [Constants.id: "9B891A5A-DAA0-4FB1-9955-48254AE3DABD",
                                       Constants.text: "Find socks",
                                       Constants.done: true,
                                       Constants.creationDate: 1684400000.0,
                                       Constants.deadlineDate: "15.07.2023"]
        
        let todoItem = TodoItem.parse(json: jsonDict)
        XCTAssertNil(todoItem)
    }
    
    func testParsingJSONWithIncorrectChangeDateFieldType() throws {
        let jsonDict: [String: Any] = [Constants.id: "9B891A5A-DAA0-4FB1-9955-48254AE3DABD",
                                       Constants.text: "Find socks",
                                       Constants.done: true,
                                       Constants.creationDate: 1684400000.0,
                                       Constants.changeDate: "12/08/2023"]
        
        let todoItem = TodoItem.parse(json: jsonDict)
        XCTAssertNil(todoItem)
    }
}
