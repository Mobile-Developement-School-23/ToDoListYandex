//
//  FileCacheCSVTests.swift
//  ToDoListYandexTests
//
//  Created by Anastasia Sharapenko on 30.06.2023.
//

import XCTest
import Foundation
@testable import ToDoListYandex

final class FileCacheCSVTests: XCTestCase {
    func testSavingTaskWithAllParametersToCSV() throws {
        guard let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory,
                                                                  in: .userDomainMask).first else {
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
            
            let checkString = """
                                   DB4ABF27-9809-41C4-89BE-1019280C365B;
                                   Drink Water;
                                   unimportant;
                                   1684482010;
                                   true;
                                   1683402000;
                                   1683422000
                                   """
            
            XCTAssertEqual(rows.count, 1)
            XCTAssertEqual(rows.first, checkString)
            
        } catch {
            XCTFail("Error loading items from file: \(error)")
            return
        }
    }
    
    func testSavingTaskWithMinimumParametersToCSV() throws {
        guard let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory,
                                                                  in: .userDomainMask).first else {
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
        guard let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory,
                                                                  in: .userDomainMask).first else {
            return
        }
        let fileURL = documentDirectoryURL.appendingPathComponent("testLoadFromCSV.csv")
        
        let taskString = """
                DB4ABF27-9809-41C4-89BE-1019280C365B;
        Default task;
        important;
        1684482010;
        true;
        1683402000;
        1683422000\n
        """
        
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
        guard let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory,
                                                                  in: .userDomainMask).first else {
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
        guard let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory,
                                                                  in: .userDomainMask).first else {
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
        guard let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory,
                                                                  in: .userDomainMask).first else {
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
