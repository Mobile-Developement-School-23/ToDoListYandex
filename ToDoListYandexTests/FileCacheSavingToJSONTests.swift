//
//  FileCacheSavingToJSONTests.swift
//  ToDoListYandexTests
//
//  Created by Анастасия Горячевская on 30.06.2023.
//

import XCTest

final class FileCacheSavingToJSONTests: XCTestCase {
    private func getFileURLByFileName(_ fileName: String) -> URL {
        guard let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory,
                                                                  in: .userDomainMask).first else {
            XCTFail("Failed creater documentDirectory URL")
        }
        return documentDirectoryURL
    }
    
    private func getTaskDictByFileURL(_ fileURL: URL) -> [String: Any]? {
        do {
            let jsonData = try Data(contentsOf: fileURL)
            guard let tasksDictionaryArray = try JSONSerialization.jsonObject(with: jsonData) as? [[String: Any]] else {
                XCTFail("Failed serialised JSON data")
            }
            
            guard let taskDictionary = tasksDictionaryArray.first else {
                XCTFail("Failed to get task item")
            }
            return taskDictionary
        } catch {
            XCTFail("Error loading items from file: \(error)")
        }
    }
    
    func testSavingTasksToJSONTaskWithAllParameters() throws {
        let fileURL = getFileURLByFileName("savingTasksTestAllParameters.json")
        
        let uuid = UUID().uuidString
        let todoItem = TodoItem(id: uuid,
                                text: "Adopt a puppy",
                                taskImportance: .important,
                                deadlineDate: Date(timeIntervalSince1970: 1684450000),
                                done: true,
                                creationDate: Date(timeIntervalSince1970: 1684404000),
                                changeDate: Date(timeIntervalSince1970: 1684406000))
        let fileCache = FileCache()
        fileCache.addNewTask(todoItem)
        fileCache.saveTasksToJSON(usingFileURL: fileURL)
        
        guard let taskDictionary = getTaskDictByFileURL(fileURL) else {
            XCTFail("Fail gettin task Dictionary")
        }
        
        guard let id = taskDictionary[Constants.id] as? String,
              let text = taskDictionary[Constants.text] as? String,
              let importanceString = taskDictionary[Constants.taskImportance] as? String,
              let importance = TodoItem.TaskImportance(rawValue: importanceString),
              let deadlineDate = taskDictionary[Constants.deadlineDate] as? TimeInterval,
              let done = taskDictionary[Constants.done] as? Bool,
              let creationDate = taskDictionary[Constants.creationDate] as? TimeInterval,
              let changeDate = taskDictionary[Constants.changeDate] as? TimeInterval
        else {
            XCTFail("Error getting correct type of task elements")
        }
        
        XCTAssertEqual(id, uuid)
        XCTAssertEqual(text, "Adopt a puppy")
        XCTAssertEqual(importance, .important)
        XCTAssertEqual(deadlineDate, 1684450000)
        XCTAssertEqual(done, true)
        XCTAssertEqual(creationDate, 1684404000)
        XCTAssertEqual(changeDate, 1684406000)
    }
    
    func testSavingTasksToJSONTaskWithMinimumParameters() throws {
        let fileURL = getFileURLByFileName("savingTasksTestMinimumParameters.json")
        
        let todoItem = TodoItem(text: "Solve a puzzle",
                                taskImportance: .usual,
                                deadlineDate: nil,
                                changeDate: nil)
        let fileCache = FileCache()
        fileCache.addNewTask(todoItem)
        fileCache.saveTasksToJSON(usingFileURL: fileURL)
        
        guard let taskDictionary = getTaskDictByFileURL(fileURL) else {
            XCTFail("Fail getting task Dictionary")
        }
        
        guard let id = taskDictionary[Constants.id] as? String,
              let text = taskDictionary[Constants.text] as? String,
              let done = taskDictionary[Constants.done] as? Bool,
              let creationDate = taskDictionary[Constants.creationDate] as? TimeInterval
        else {
            XCTFail("Error getting correct type of task")
        }
        
        XCTAssert(UUID(uuidString: id) != nil)
        XCTAssertEqual(text, "Solve a puzzle")
        XCTAssertNil(taskDictionary[Constants.taskImportance])
        XCTAssertNil(taskDictionary[Constants.deadlineDate])
        XCTAssertEqual(documentDirectoryURL, false)
        XCTAssertNil(taskDictionary[Constants.changeDate])
    }
}
