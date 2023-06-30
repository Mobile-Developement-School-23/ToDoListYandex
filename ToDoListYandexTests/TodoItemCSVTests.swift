//
//  TodoItemCSVTests.swift
//  ToDoListYandexTests
//
//  Created by Anastasia Sharapenko on 6/16/23.
//

import XCTest
import Foundation
@testable import ToDoListYandex

final class TodoItemCSVTests: XCTestCase {
    
    func testFormingCSVWithAllParameters() throws {
        let task = TodoItem(id: "D69F0A30-603F-4F99-9140-2049E054297A",
                            text: "Do the hometasks",
                            taskImportance: .unimportant,
                            deadlineDate: Date(timeIntervalSince1970: 1686800000),
                            done: true,
                            creationDate: Date(timeIntervalSince1970: 1686050000),
                            changeDate: Date(timeIntervalSince1970: 1686120000))
        
        let correctOutputCSVString = """
        D69F0A30-603F-4F99-9140-2049E054297A;Do the hometasks;
        unimportant;1686800000;true;1686050000;1686120000
"""
        
        XCTAssertEqual(task.csv, correctOutputCSVString)
    }
    
    func testFormingCSVWithMinimumParameters() throws {
        let task = TodoItem(text: "Do the hometasks",
                            taskImportance: .usual,
                            deadlineDate: nil,
                            creationDate: Date(timeIntervalSince1970: 1686050000),
                            changeDate: nil)
        
        let correctOutputCSVStringWithoutId = ";Do the hometasks;;;false;1686050000;"
        guard let uuid = task.csv.components(separatedBy: ";").first else {
            XCTFail("There are no separators ;")
            return
        }
        
        XCTAssert(task.csv.hasSuffix(correctOutputCSVStringWithoutId))
        XCTAssert(UUID(uuidString: uuid) != nil)
    }
    
    func testParseCSVWithAllCorrectParameters() throws {
        let csvString = """
        D69F0A30-603F-4F99-9140-2049E054297A;Buy groceries;
        important;1686800000;true;1686050000;1686120000
"""
        
        let todoItem = TodoItem.parse(csv: csvString)
        
        XCTAssertEqual(todoItem?.id, "D69F0A30-603F-4F99-9140-2049E054297A")
        XCTAssertEqual(todoItem?.text, "Buy groceries")
        XCTAssertEqual(todoItem?.taskImportance, TodoItem.TaskImportance.important)
        XCTAssertEqual(todoItem?.deadlineDate, Date(timeIntervalSince1970: 1686800000))
        XCTAssertEqual(todoItem?.done, true)
        XCTAssertEqual(todoItem?.creationDate, Date(timeIntervalSince1970: 1686050000))
        XCTAssertEqual(todoItem?.changeDate, Date(timeIntervalSince1970: 1686120000))
    }
    
    func testParseCSVWithMinimumCorrectParameters() throws {
        let csvString = "15A4B2EB-52C1-4CCE-A7EF-D8E841C7552E;Get a job at Yandex;;;false;1686060000;"
        
        let todoItem = TodoItem.parse(csv: csvString)
        
        XCTAssertEqual(todoItem?.id, "15A4B2EB-52C1-4CCE-A7EF-D8E841C7552E")
        XCTAssertEqual(todoItem?.text, "Get a job at Yandex")
        XCTAssertEqual(todoItem?.taskImportance, TodoItem.TaskImportance.usual)
        XCTAssertNil(todoItem?.deadlineDate)
        XCTAssertEqual(todoItem?.done, false)
        XCTAssertEqual(todoItem?.creationDate, Date(timeIntervalSince1970: 1686060000))
        XCTAssertNil(todoItem?.changeDate)
    }
    
    func testParseCSVWithoutId() throws {
        let csvString = ";Default task;;;false;1686063000;"
        let todoItem = TodoItem.parse(csv: csvString)
        XCTAssertNil(todoItem)
    }
    
    func testParseCSVWithEmptyText() throws {
        let csvString = "15A4B2EB-52C1-4CCE-A7EF-D8E841C7552E;;;;false;1686063000;"
        let todoItem = TodoItem.parse(csv: csvString)
        XCTAssertNil(todoItem)
    }
    
    func testParseCSVWithIncorrectTaskImportance() throws {
        let csvString = "15A4B2EB-52C1-4CCE-A7EF-D8E841C7552E;Default task;super;;false;1686063000;"
        let todoItem = TodoItem.parse(csv: csvString)
        XCTAssertNil(todoItem)
    }
    
    func testParseCSVWithIncorrectDeadlineDate() throws {
        let csvString = "15A4B2EB-52C1-4CCE-A7EF-D8E841C7552E;Default task;important;May 17;false;1686063000;"
        let todoItem = TodoItem.parse(csv: csvString)
        XCTAssertNil(todoItem)
    }
    
    func testParseCSVWithIncorrectDoneField() throws {
        let csvString = "15A4B2EB-52C1-4CCE-A7EF-D8E841C7552E;Default task;;;1;1686063000;"
        let todoItem = TodoItem.parse(csv: csvString)
        XCTAssertNil(todoItem)
    }
    
    func testParseCSVWithoutDoneField() throws {
        let csvString = "15A4B2EB-52C1-4CCE-A7EF-D8E841C7552E;Default task;;;;1686063000;"
        let todoItem = TodoItem.parse(csv: csvString)
        XCTAssertNil(todoItem)
    }
    
    func testParseCSVWithIncorrectCreationDate() throws {
        let csvString = "15A4B2EB-52C1-4CCE-A7EF-D8E841C7552E;Default task;;;false;12/09/2022;"
        let todoItem = TodoItem.parse(csv: csvString)
        XCTAssertNil(todoItem)
    }
    
    func testParseCSVWithoutCreationDate() throws {
        let csvString = "15A4B2EB-52C1-4CCE-A7EF-D8E841C7552E;Default task;;;false;;"
        let todoItem = TodoItem.parse(csv: csvString)
        XCTAssertNil(todoItem)
    }
    
    func testParseCSVWithIncorrectChangeDate() throws {
        let csvString = "15A4B2EB-52C1-4CCE-A7EF-D8E841C7552E;Default task;;;false;1686063000;First March"
        let todoItem = TodoItem.parse(csv: csvString)
        XCTAssertNil(todoItem)
    }
    
    func testParseEmptyCSV() throws {
        let csvString = ""
        let todoItem = TodoItem.parse(csv: csvString)
        XCTAssertNil(todoItem)
    }
    
    func testParseCSVWithLessParameters() throws {
        let csvString = "15A4B2EB-52C1-4CCE-A7EF-D8E841C7552E;Default task;;false;1686063000"
        let todoItem = TodoItem.parse(csv: csvString)
        XCTAssertNil(todoItem)
    }
    
    func testParseCSVWithLineBreak() throws {
        let csvString = "15A4B2EB-52C1-4CCE-A7EF-D8E841C7552E;Default task;;;false;1686060000;\n"
        let todoItem = TodoItem.parse(csv: csvString)
        XCTAssertNil(todoItem)
    }
    
    func testParseCSVWithSeparatorInText() throws {
        let csvString = "15A4B2EB-52C1-4CCE-A7EF-D8E841C7552E;Default; task;;;false;1686060000;\n"
        let todoItem = TodoItem.parse(csv: csvString)
        XCTAssertNil(todoItem)
    }
}
