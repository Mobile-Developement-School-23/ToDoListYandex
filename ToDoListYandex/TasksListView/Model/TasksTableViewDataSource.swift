//
//  TasksTableViewDataSource.swift
//  ToDoListYandex
//
//  Created by Анастасия Горячевская on 26.06.2023.
//

import UIKit

class TasksTableViewDataSource: NSObject {
    
    private var tasksSave: [TodoItem] = []
    
    private var tasks: [TodoItem] = []
    
    private var isDoneTasksShown: Bool = false
    
    private let fileCache = FileCache()
    
    var newTaskButtonTappedHandler: (() -> Void)?
    
    override init() {
        super.init()
        loadTasks()
    }
    
    func loadTasks() {
        fileCache.loadAllTasksFromJSON(usingFileName: Constants.fileName)
        tasks = fileCache.tasks
    }
    
    func numberOfTasks() -> Int {
        tasks.count
    }
    
    func task(at row: Int) -> TodoItem? {
        if row > numberOfTasks() - 1 || row < 0 {
            return nil
        }
        return tasks[row]
    }
    
    func removeTask(at row: Int) -> TodoItem {
        let taskToDelete = tasks.remove(at: row)
        fileCache.removeTaskById(taskToDelete.id)
        fileCache.saveTasksToJSON(usingFileName: Constants.fileName)
        return taskToDelete
    }
    
    func updateTaskDone(at row: Int) {
        tasks[row].done = !tasks[row].done
        fileCache.replaceTask(tasks[row], atIndex: row)
        fileCache.saveTasksToJSON(usingFileName: Constants.fileName)
    }
    
    func getDoneTasksNumber() -> Int {
        tasks.filter({ $0.done }).count
    }
    
    func showDoneTasks() {
        if isDoneTasksShown {
            tasks = tasksSave
        } else {
            tasksSave = tasks
            tasks = tasks.filter({ $0.done })
        }
        isDoneTasksShown = !isDoneTasksShown
    }
}

extension TasksTableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfTasks() + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return getTasksListInfoViewCell(tableView, cellForRowAt: indexPath)
        case numberOfTasks() + 1:
            return getNewTaskTableViewCell(tableView, cellForRowAt: indexPath)
        default:
            return getTaskTableViewCell(tableView, cellForRowAt: indexPath)
        }
    }
    
    private func getTasksListInfoViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! TasksListInfoViewCell
        cell.setDoneNumber(getDoneTasksNumber())
        cell.separatorInset.right = .greatestFiniteMagnitude
        
        cell.showDoneTasksTappedHandler = { [weak self] in
            self?.showDoneTasks()
            tableView.reloadData()
        }
        
        return cell
    }
    
    private func getTaskTableViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskTableViewCell
        
        cell.setInfo(taskText: tasks[indexPath.row - 1].text, importance: tasks[indexPath.row - 1].taskImportance, done: tasks[indexPath.row - 1].done, deadline:  tasks[indexPath.row - 1].deadlineDate)
        
        cell.doneButtonTappedHandler = { [weak self] in
            self?.updateTaskDone(at: indexPath.row - 1)
            tableView.reloadData()
        }
        
        return cell
    }
    
    private func getNewTaskTableViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newCell", for: indexPath) as! NewTaskTableViewCell
        
        cell.separatorInset.right = .greatestFiniteMagnitude
        
        cell.newTaskButtonTappedHandler = { [weak self] in
            self?.newTaskButtonTappedHandler?()
        }
        
        return cell
    }
}

