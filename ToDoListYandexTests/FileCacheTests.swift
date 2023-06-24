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

    func testSavingTasksToJSONTaskWithAllParameters() throws {
        guard let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            XCTFail("Failed creater documentDirectory URL")
            return
        }
        let fileURL = documentDirectoryURL.appendingPathComponent("savingTasksTestAllParameters.json")
        
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

        do {
            let jsonData = try Data(contentsOf: fileURL)
            guard let tasksDictionaryArray = try JSONSerialization.jsonObject(with: jsonData) as? [[String: Any]] else {
                XCTFail("Failed serialised JSON data")
                return
            }
            
            guard let taskDictionary = tasksDictionaryArray.first else {
                XCTFail("Failed to get task item")
                return
            }
            
            XCTAssertEqual(taskDictionary[Constants.id] as! String, uuid)
            XCTAssertEqual(taskDictionary[Constants.text] as! String, "Adopt a puppy")
            XCTAssertEqual(TodoItem.TaskImportance(rawValue: taskDictionary[Constants.taskImportance] as! String), .important)
            XCTAssertEqual(taskDictionary[Constants.deadlineDate] as! TimeInterval, 1684450000)
            XCTAssertEqual(taskDictionary[Constants.done] as! Bool, true)
            XCTAssertEqual(taskDictionary[Constants.creationDate] as! TimeInterval, 1684404000)
            XCTAssertEqual(taskDictionary[Constants.changeDate] as! TimeInterval, 1684406000)
            
        } catch {
            XCTFail("Error loading items from file: \(error)")
            return
        }
    }
    
    func testSavingTasksToJSONTaskWithMinimumParameters() throws {
        guard let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            XCTFail("Failed creater documentDirectory URL")
            return
        }
        let fileURL = documentDirectoryURL.appendingPathComponent("savingTasksTestMinimumParameters.json")
        
        let todoItem = TodoItem(text: "Solve a puzzle",
                                taskImportance: .usual,
                                deadlineDate: nil,
                                changeDate: nil)
        let fileCache = FileCache()
        fileCache.addNewTask(todoItem)
        fileCache.saveTasksToJSON(usingFileURL: fileURL)

        do {
            let jsonData = try Data(contentsOf: fileURL)
            guard let tasksDictionaryArray = try JSONSerialization.jsonObject(with: jsonData) as? [[String: Any]] else {
                XCTFail("Failed serialised JSON data")
                return
            }
            
            guard let taskDictionary = tasksDictionaryArray.first else {
                XCTFail("Failed to get task item")
                return
            }

            XCTAssert(UUID(uuidString: taskDictionary[Constants.id] as! String) != nil)
            XCTAssertEqual(taskDictionary[Constants.text] as! String, "Solve a puzzle")
            XCTAssertNil(taskDictionary[Constants.taskImportance])
            XCTAssertNil(taskDictionary[Constants.deadlineDate])
            XCTAssertEqual(taskDictionary[Constants.done] as! Bool, false)
            XCTAssert(taskDictionary[Constants.creationDate] as? TimeInterval != nil)
            XCTAssertNil(taskDictionary[Constants.changeDate])
            
        } catch {
            XCTFail("Error loading items from file: \(error)")
            return
        }
    }
    
    func testParseTaskWithAllParameters() throws {
        guard let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let fileURL = documentDirectoryURL.appendingPathComponent("parseJSONTestAllParameters.json")
        
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
        guard let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let fileURL = documentDirectoryURL.appendingPathComponent("parseJSONTestMinimumParameters.json")
        
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
        guard let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let fileURL = documentDirectoryURL.appendingPathComponent("parseJSONTestAllParameters.json")
        
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
        guard let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        let fileURL = documentDirectoryURL.appendingPathComponent("testNonExistingFile.json")
        
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
    
    func testSavingTaskWithAllParametersToCSV() throws {
        guard let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let fileURL = documentDirectoryURL.appendingPathComponent("testSavingCSVWithAllParameters.csv")
        
        let task = TodoItem(id: "DB4ABF27-9809-41C4-89BE-1019280C365B",
                            text: "Drink Water",
                            taskImportance: .unimportant,
                            deadlineDate: Date(timeIntervalSince1970: 1684482010),
                            done: true,
                            creationDate: Date(timeIntervalSince1970: 1683402000),
                            changeDate: Date(timeIntervalSince1970: 1683422000))
        
        let fileCache = FileCache()
        fileCache.addNewTask(task)
        
        fileCache.saveTasksToCSV(usingFileURL: fileURL)
        
        do {
            let csvString = try String(contentsOf: fileURL, encoding: .utf8)
            
            let rows = csvString.components(separatedBy: "\n")
            
            XCTAssertEqual(rows.count, 1)
            XCTAssertEqual(rows.first, "DB4ABF27-9809-41C4-89BE-1019280C365B;Drink Water;unimportant;1684482010;true;1683402000;1683422000")
            
        } catch {
            XCTFail("Error loading items from file: \(error)")
            return
        }
    }
    
    func testSavingTaskWithMinimumParametersToCSV() throws {
        guard let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let fileURL = documentDirectoryURL.appendingPathComponent("testSavingCSVWithMinimumParameters.csv")
        
        let task = TodoItem(text: "Eat food",
                            taskImportance: .usual,
                            deadlineDate: nil,
                            creationDate: Date(timeIntervalSince1970: 1683403400),
                            changeDate: nil)
        
        let fileCache = FileCache()
        fileCache.addNewTask(task)
        
        fileCache.saveTasksToCSV(usingFileURL: fileURL)
        
        do {
            let csvString = try String(contentsOf: fileURL, encoding: .utf8)
            let rows = csvString.components(separatedBy: "\n")
            
            let correctOutputCSVStringWithoutId = ";Eat food;;;false;1683403400;"
            
            XCTAssertEqual(rows.count, 1)
            XCTAssert(rows.first!.hasSuffix(correctOutputCSVStringWithoutId))
            
            guard let uuid = rows.first!.components(separatedBy: ";").first else {
                XCTFail("There are no separators ;")
                return
            }
            
            XCTAssert(UUID(uuidString: uuid) != nil)
        } catch {
            XCTFail("Error loading items from file: \(error)")
            return
        }
    }
    
    func testLoadTaskFromCSVWithAllParaneters() throws {
        guard let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let fileURL = documentDirectoryURL.appendingPathComponent("testLoadFromCSV.csv")
        
        let taskString = "DB4ABF27-9809-41C4-89BE-1019280C365B;Default task;important;1684482010;true;1683402000;1683422000\n"
        
        do {
            try taskString.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("Error saving items to file: \(error)")
        }
        
        let fileCache = FileCache()
        fileCache.loadTasksFromCSV(usingFileURL: fileURL)
        
        XCTAssertEqual(fileCache.tasks.count, 1)
        let task = fileCache.tasks.first
        XCTAssertEqual(task?.id, "DB4ABF27-9809-41C4-89BE-1019280C365B")
        XCTAssertEqual(task?.text, "Default task")
        XCTAssertEqual(task?.taskImportance, .important)
        XCTAssertEqual(task?.deadlineDate, Date(timeIntervalSince1970: 1684482010))
        XCTAssertEqual(task?.done, true)
        XCTAssertEqual(task?.creationDate, Date(timeIntervalSince1970: 1683402000))
        XCTAssertEqual(task?.changeDate, Date(timeIntervalSince1970: 1683422000))
        
    }
    
    func testLoadTaskFromCSVWithMinimumParaneters() throws {
        guard let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let fileURL = documentDirectoryURL.appendingPathComponent("testLoadFromCSVWithMinimumParameters.csv")
        
        let taskString = "DB4ABF27-9809-41C4-89BE-1019280C365B;Default task;;;false;1683402000;\n"
        
        do {
            try taskString.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("Error saving items to file: \(error)")
        }
        
        let fileCache = FileCache()
        fileCache.loadTasksFromCSV(usingFileURL: fileURL)
        
        XCTAssertEqual(fileCache.tasks.count, 1)
        let task = fileCache.tasks.first
        XCTAssertEqual(task?.id, "DB4ABF27-9809-41C4-89BE-1019280C365B")
        XCTAssertEqual(task?.text, "Default task")
        XCTAssertEqual(task?.taskImportance, .usual)
        XCTAssertNil(task?.deadlineDate)
        XCTAssertEqual(task?.done, false)
        XCTAssertEqual(task?.creationDate, Date(timeIntervalSince1970: 1683402000))
        XCTAssertNil(task?.changeDate)
    }
    
    func testLoadFewTasksFromCSV() {
        guard let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let fileURL = documentDirectoryURL.appendingPathComponent("testLoadFewTasksFromCSV.csv")
        
        let taskString = """
        DB4ABF27-9809-41C4-89BE-1019280C365B;Default task;;;false;1683402000;\n
        15A4B2EB-52C1-4CCE-A7EF-D8E841C7552E;New task;important;1685902000;true;1683402000;1683402900\n
        D69F0A30-603F-4F99-9140-2049E054297A;Write new tasks;;1685912000;true;1683402000;\n
        """
        
        do {
            try taskString.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("Error saving items to file: \(error)")
        }
        
        let fileCache = FileCache()
        fileCache.loadTasksFromCSV(usingFileURL: fileURL)
        XCTAssertEqual(fileCache.tasks.count, 3)
    }
    
    func testLoadFewTasksFromCSVWithIncorrectInTheMiddle() {
        guard let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let fileURL = documentDirectoryURL.appendingPathComponent("testLoadFewTasksFromCSV.csv")
        
        let taskString = """
        DB4ABF27-9809-41C4-89BE-1019280C365B;Default task;;;false;1683402000;\n
        ;New task;important;1685902000;;1683402000;1683402900\n
        D69F0A30-603F-4F99-9140-2049E054297A;Write new tasks;;1685912000;true;1683402000;\n
        """
        
        do {
            try taskString.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("Error saving items to file: \(error)")
        }
        
        let fileCache = FileCache()
        fileCache.loadTasksFromCSV(usingFileURL: fileURL)
        XCTAssertEqual(fileCache.tasks.count, 2)
        XCTAssertEqual(fileCache.tasks.first?.id, "DB4ABF27-9809-41C4-89BE-1019280C365B")
        XCTAssertEqual(fileCache.tasks.last?.id, "D69F0A30-603F-4F99-9140-2049E054297A")
    }
}
