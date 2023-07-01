//
//  FileCacheTests.swift
//  ToDoListYandexTests
//
//  Created by Anastasia Sharapenko on 6/16/23.
//

import XCTest
import Foundation
@testable import ToDoListYandex


final class FileCacheTests: XCTestCase {
    
    func testAppendingTask() {
        let task = TodoItem(id: UUID().uuidString,
                            text: "Solve algorithm tasks",
                            taskImportance: .usual,
                            deadlineDate: Date(timeIntervalSince1970: 1686900300),
                            done: true,
                            creationDate: Date(timeIntervalSince1970: 1686700800),
                            changeDate: Date(timeIntervalSince1970: 1686700880))
        let fileCache = FileCache()
        fileCache.addNewTask(task)
        
        XCTAssertEqual(fileCache.tasks.count, 1)
        XCTAssertEqual(fileCache.tasks.last, task)
    }
    
    func testAppendingOneTaskTwoTimes() {
        let task = TodoItem(id: UUID().uuidString,
                            text: "Solve algorithm tasks",
                            taskImportance: .usual,
                            deadlineDate: Date(timeIntervalSince1970: 1686900300),
                            done: true,
                            creationDate: Date(timeIntervalSince1970: 1686700800),
                            changeDate: Date(timeIntervalSince1970: 1686700880))
        let fileCache = FileCache()
        fileCache.addNewTask(task)
        fileCache.addNewTask(task)
        
        XCTAssertEqual(fileCache.tasks.count, 1)
        XCTAssertEqual(fileCache.tasks.last, task)
    }
    
    func testAppendingTasksWithSameId() {
        let uuid = UUID().uuidString
        let task = TodoItem(id: uuid,
                            text: "Solve algorithm tasks",
                            taskImportance: .usual,
                            deadlineDate: Date(timeIntervalSince1970: 1686900300),
                            done: true,
                            creationDate: Date(timeIntervalSince1970: 1686700800),
                            changeDate: Date(timeIntervalSince1970: 1686700880))
        let task2 = TodoItem(id: uuid,
                             text: "Some another task",
                             taskImportance: .important,
                             deadlineDate: Date(timeIntervalSince1970: 1686900320),
                             done: false,
                             creationDate: Date(timeIntervalSince1970: 1686700830),
                             changeDate: Date(timeIntervalSince1970: 1686700890))
        let fileCache = FileCache()
        fileCache.addNewTask(task)
        fileCache.addNewTask(task2)
        
        XCTAssertEqual(fileCache.tasks.count, 1)
        XCTAssertNotEqual(fileCache.tasks.last, task)
        XCTAssertEqual(fileCache.tasks.last, task2)
    }
    
    func testRemovingTaskById() {
        let uuid = UUID().uuidString
        let task = TodoItem(id: uuid,
                            text: "Solve algorithm tasks",
                            taskImportance: .usual,
                            deadlineDate: Date(timeIntervalSince1970: 1686900300),
                            done: true,
                            creationDate: Date(timeIntervalSince1970: 1686700800),
                            changeDate: Date(timeIntervalSince1970: 1686700880))
        let task2 = TodoItem(id: UUID().uuidString,
                             text: "Some another task",
                             taskImportance: .important,
                             deadlineDate: Date(timeIntervalSince1970: 1686900320),
                             done: false,
                             creationDate: Date(timeIntervalSince1970: 1686700830),
                             changeDate: Date(timeIntervalSince1970: 1686700890))
        let fileCache = FileCache()
        fileCache.addNewTask(task)
        fileCache.addNewTask(task2)
        fileCache.removeTaskById(uuid)
        
        XCTAssertEqual(fileCache.tasks.count, 1)
        XCTAssertEqual(fileCache.tasks.last, task2)
    }
    
    func testParseTaskWithAllParameters() throws {
        let fileURL = getFileURLByFileName("parseJSONTestAllParameters.json")
        
        let uuid = UUID().uuidString
        let tasksDictionariesArray = [[Constants.id: uuid,
                                       Constants.text: "Save passwords",
                                       Constants.taskImportance: "unimportant",
                                       Constants.deadlineDate: 1684482000,
                                       Constants.done: true,
                                       Constants.creationDate: 1684436000,
                                       Constants.changeDate: 1684439400]]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: tasksDictionariesArray)
            try jsonData.write(to: fileURL)
        } catch {
            XCTFail("Error saving items from file: \(error)")
        }
        
        let fileCache = FileCache()
        fileCache.loadAllTasksFromJSON(usingFileURL: fileURL)
        
        XCTAssertEqual(fileCache.tasks.count, 1)
        
        let task = fileCache.tasks.first
        XCTAssertEqual(task?.id, uuid)
        XCTAssertEqual(task?.text, "Save passwords")
        XCTAssertEqual(task?.taskImportance, .unimportant)
        XCTAssertEqual(task?.deadlineDate, Date(timeIntervalSince1970: 1684482000))
        XCTAssertEqual(task?.done, true)
        XCTAssertEqual(task?.creationDate, Date(timeIntervalSince1970: 1684436000))
        XCTAssertEqual(task?.changeDate, Date(timeIntervalSince1970: 1684439400))
    }
    
    func testParseTaskWithMinimumParameters() throws {
        let fileURL = getFileURLByFileName("parseJSONTestMinimumParameters.json")
        
        let uuid = UUID().uuidString
        let tasksDictionariesArray = [[Constants.id: uuid,
                                       Constants.text: "Print documents",
                                       Constants.done: false,
                                       Constants.creationDate: 1684443000]]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: tasksDictionariesArray)
            try jsonData.write(to: fileURL)
        } catch {
            XCTFail("Error saving items from file: \(error)")
        }
        
        let fileCache = FileCache()
        fileCache.loadAllTasksFromJSON(usingFileURL: fileURL)
        
        XCTAssertEqual(fileCache.tasks.count, 1)
        
        let task = fileCache.tasks.first
        XCTAssertEqual(task?.id, uuid)
        XCTAssertEqual(task?.text, "Print documents")
        XCTAssertEqual(task?.taskImportance, .usual)
        XCTAssertNil(task?.deadlineDate)
        XCTAssertEqual(task?.done, false)
        XCTAssertEqual(task?.creationDate, Date(timeIntervalSince1970: 1684443000))
        XCTAssertNil(task?.changeDate)
    }
    
    func testParseFewTasks() throws {
        let fileURL = getFileURLByFileName("parseJSONTestAllParameters.json")
        
        let tasksDictionariesArray = [[Constants.id: UUID().uuidString,
                                       Constants.text: "Learn Swift",
                                       Constants.taskImportance: "important",
                                       Constants.deadlineDate: 1684482000,
                                       Constants.done: true,
                                       Constants.creationDate: 1684436000,
                                       Constants.changeDate: 1684439400],
                                      [Constants.id: UUID().uuidString,
                                       Constants.text: "Learn ObjC",
                                       Constants.done: false,
                                       Constants.creationDate: 1684443000]]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: tasksDictionariesArray)
            try jsonData.write(to: fileURL)
        } catch {
            XCTFail("Error saving items from file: \(error)")
        }
        
        let fileCache = FileCache()
        fileCache.loadAllTasksFromJSON(usingFileURL: fileURL)
        
        XCTAssertEqual(fileCache.tasks.count, 2)
    }
    
    func testParseTasksFromNonExistingFile() throws {
        let fileURL = getFileURLByFileName("testNonExistingFile.json")
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch {
                return
            }
        }
        
        XCTAssertFalse(FileManager.default.fileExists(atPath: fileURL.path))
        
        let fileCache = FileCache()
        fileCache.loadAllTasksFromJSON(usingFileURL: fileURL)
        
        XCTAssertEqual(fileCache.tasks.count, 0)
    }
}
