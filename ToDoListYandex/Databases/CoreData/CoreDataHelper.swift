//
//  CoreDataHelper.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 13.07.2023.
//

import CoreData
import CocoaLumberjackSwift
import UIKit


class CoreDataHelper: DBProtocol {
    
    private var tasks: [NSManagedObject] = []
    
    private var managedContext: NSManagedObjectContext? = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }()
    
    func getTasks() -> [TodoItem] {
        tasks.compactMap { getTodoItemFromNSManagedObject($0) }
    }
    
    func loadTasksFromDB() {
        guard let managedContext = managedContext else { return }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TodoItemCoreData")
        
        do {
            tasks = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            DDLogError("CoreData Error loading tasks: \(error)")
        }
    }
    
    func saveTask(_ todoItem: TodoItem) {
        deleteTaskById(todoItem.id)
        
        guard let managedContext = managedContext else { return }
        
        let entity = NSEntityDescription.entity(forEntityName: "TodoItemCoreData", in: managedContext)!
        
        let task = NSManagedObject(entity: entity, insertInto: managedContext)

        task.setValue(todoItem.id, forKeyPath: Constants.id)
        task.setValue(todoItem.text, forKeyPath: Constants.text)
        task.setValue(todoItem.taskImportance.rawValue, forKeyPath: Constants.taskImportance)
        task.setValue(todoItem.deadlineDate, forKeyPath: Constants.deadlineDate)
        task.setValue(todoItem.done, forKeyPath: Constants.done)
        task.setValue(todoItem.creationDate, forKeyPath: Constants.creationDate)
        task.setValue(todoItem.changeDate, forKeyPath: Constants.changeDate)
        task.setValue(todoItem.hexColor, forKeyPath: Constants.color)
        
        do {
            try managedContext.save()
            tasks.append(task)
        } catch let error as NSError {
            DDLogError("CoreData Error saving task: \(error)")
        }
    }
    
    func deleteTaskById(_ id: String) {
        guard let managedContext = managedContext else { return }
        
        guard let index = tasks.firstIndex(where: {$0.value(forKey: Constants.id) as? String == id})  else { return }

        managedContext.delete(tasks[index])
        tasks.remove(at: index)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            DDLogError("CoreData Error deleting task: \(error)")
        }
    }
    
    func updateTask(_ todoItem: TodoItem) {
        deleteTaskById(todoItem.id)
        saveTask(todoItem)
    }
    
    func deleteAllTasks() {
        guard let managedContext = managedContext else { return }
        
        for object in tasks {
            managedContext.delete(object)
        }
        
        tasks = []
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            DDLogError("CoreData Error deleting all tasks: \(error)")
        }
    }
    
    private func getTodoItemFromNSManagedObject(_ object: NSManagedObject) -> TodoItem? {
        guard let id = object.value(forKey: Constants.id) as? String,
              let text = object.value(forKey: Constants.text) as? String,
              let importance = object.value(forKey: Constants.taskImportance) as? String,
              let deadlineDate = object.value(forKey: Constants.deadlineDate) as? Date?,
              let doneNumber = object.value(forKey: Constants.done) as? NSNumber,
              let done = doneNumber as? Bool,
              let creationDate = object.value(forKey: Constants.creationDate) as? Date,
              let changeDate = object.value(forKey: Constants.changeDate) as? Date?,
              let color = object.value(forKey: Constants.color) as? String?
        else { return nil }
        
        return TodoItem(id: id,
                        text: text,
                        taskImportance: TodoItem.TaskImportance.getTaskImportanceFromString(importance),
                        deadlineDate: deadlineDate,
                        done: done,
                        creationDate: creationDate,
                        changeDate: changeDate,
                        textColor: color)
    }
}
