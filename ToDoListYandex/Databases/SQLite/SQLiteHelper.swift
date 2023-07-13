//
//  SQLiteHelper.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 12.07.2023.
//

import Foundation
import CocoaLumberjackSwift
import SQLite


class SQLiteHelper: DBProtocol {
    private let fileName = "myTasksSQLite.sqlite3"
    
    private var db: Connection?
    private let tasksTable = Table("tasks")
    
    private var tasks: [TodoItem] = []
    
    init() {
        createConnection()
        createTable()
    }
    
    private func createConnection() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!

        do {
            self.db = try Connection("\(path)/\(fileName)")
        } catch {
            DDLogError("Error in create connection with SQLite")
        }
    }
    
    private func createTable() {
        do {
            try db?.run(tasksTable.create(ifNotExists: true) { table in
                table.column(Columns.id, primaryKey: true)
                table.column(Columns.text)
                table.column(Columns.taskImportance)
                table.column(Columns.deadlineDate)
                table.column(Columns.done)
                table.column(Columns.creationDate)
                table.column(Columns.changeDate)
                table.column(Columns.textColor)
            })
        } catch {
            DDLogError("Error in creation table with SQLite")
        }
    }
    
    func getTasks() -> [TodoItem] {
        tasks
    }
    
    func loadTasksFromDB() {
        do {
            guard let items = try db?.prepare(tasksTable) else {
                return
            }
            
            for item in items {
                let importance = item[Columns.taskImportance]
                
                let todoItem = TodoItem(id: item[Columns.id],
                                        text: item[Columns.text],
                                        taskImportance: TodoItem.TaskImportance.getTaskImportanceFromString(importance),
                                        deadlineDate: item[Columns.deadlineDate],
                                        done: item[Columns.done],
                                        creationDate: item[Columns.creationDate],
                                        changeDate: item[Columns.changeDate],
                                        textColor: item[Columns.textColor])
                tasks.append(todoItem)
            }
        } catch {
            DDLogError("Error in loading tasks SQLite")
        }
    }
    
    
    func saveTask(_ todoItem: TodoItem) {
        deleteTaskById(todoItem.id)
        do {
            try db?.run(tasksTable.insert(Columns.id <- todoItem.id,
                                          Columns.text <- todoItem.text,
                                          Columns.taskImportance <- todoItem.taskImportance.rawValue,
                                          Columns.deadlineDate <- todoItem.deadlineDate,
                                          Columns.done <- todoItem.done,
                                          Columns.creationDate <- todoItem.creationDate,
                                          Columns.changeDate <- todoItem.changeDate,
                                          Columns.textColor <- todoItem.hexColor))
            tasks.append(todoItem)
        } catch {
            DDLogError("Error in saving/updating task SQLite")
        }
    }
    
    func deleteTaskById(_ id: String) {
        do {
            let itemToDelete = tasksTable.filter(Columns.id == id)
            try db?.run(itemToDelete.delete())
            
            tasks.removeAll(where: { $0.id == id })
        } catch {
            DDLogError("Error in deleting/updating task SQLite")
        }
    }
    
    func updateTask(_ todoItem: TodoItem) {
        deleteTaskById(todoItem.id)
        saveTask(todoItem)
    }
    
    func deleteAllTasks() {
        do {
            try db?.run(tasksTable.delete())
            tasks = []
        } catch {
            DDLogError("Error in deleting all tasks SQLite")
        }
    }
}
