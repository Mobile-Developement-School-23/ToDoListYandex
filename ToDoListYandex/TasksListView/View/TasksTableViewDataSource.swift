//
//  TasksTableViewDataSource.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 26.06.2023.
//

import UIKit
import FileCache

class TasksTableViewDataSource: NSObject {
    
    private var tasksSave: [TodoItem] = []
    
    private var tasks: [TodoItem] = []
    
    private var isDoneTasksShown: Bool = false
    
    private let fileCache = FileCache()
    
    weak var view: TasksListViewController?
    
    private let networkModel = NetworkModel()
    
    var newTaskButtonTappedHandler: (() -> Void)?
    
    override init() {
        super.init()
        loadTasks()
    }
    
    func loadTasks() {
        networkModel.loadTasks {
            self.tasks = self.networkModel.getTasks().sorted(by: { $0.creationDate > $1.creationDate })
            DispatchQueue.main.async {
                self.view?.tasksTableView.reloadData()
            }
        }
    }
    
    func numberOfTasks() -> Int {
        tasks.count
    }
    
    func addTask(_ task: TodoItem) {
        networkModel.addTask(task, completion: {
            self.loadTasks()
        })
    }
    
    func task(at row: Int) -> TodoItem? {
        if row > numberOfTasks() - 1 || row < 0 {
            return nil
        }
        return tasks[row]
    }
    
    func removeTask(at row: Int) -> TodoItem {
        let taskToDelete = tasks.remove(at: row)
        deleteTask(byId: taskToDelete.id)
        return taskToDelete
    }
    
    func deleteTask(byId id: String) {
        networkModel.deleteTask(id: id) {
            self.loadTasks()
        }
    }
    
    func updateTask(_ task: TodoItem) {
        networkModel.updateTask(task, completion: {
            self.loadTasks()
        })
    }
    
    func updateTaskDone(at row: Int) {
        let updatedTask = TodoItem(id: tasks[row].id,
                                   text: tasks[row].text,
                                   taskImportance: tasks[row].taskImportance,
                                   deadlineDate: tasks[row].deadlineDate,
                                   done: !tasks[row].done,
                                   creationDate: tasks[row].creationDate,
                                   changeDate: tasks[row].changeDate,
                                   textColor: tasks[row].hexColor)
        
        networkModel.updateTask(updatedTask) {
            self.loadTasks()
        }
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
    
    @MainActor private func getTasksListInfoViewCell(_ tableView: UITableView,
                                                     cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellBasic = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath)
        guard let cell = cellBasic as? TasksListInfoViewCell else { return cellBasic }
        
        cell.setDoneNumber(getDoneTasksNumber())
        cell.separatorInset.right = .greatestFiniteMagnitude
        
        cell.showDoneTasksTappedHandler = { [weak self] in
            self?.showDoneTasks()
            tableView.reloadData()
        }
        
        return cell
    }
    
    @MainActor private func getTaskTableViewCell(_ tableView: UITableView,
                                                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellBasic = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        guard let cell = cellBasic as? TaskTableViewCell else { return cellBasic }
        
        cell.setInfo(taskText: tasks[indexPath.row - 1].text,
                     importance: tasks[indexPath.row - 1].taskImportance,
                     done: tasks[indexPath.row - 1].done,
                     deadline: tasks[indexPath.row - 1].deadlineDate)
        
        cell.doneButtonTappedHandler = { [weak self] in
            self?.updateTaskDone(at: indexPath.row - 1)
            tableView.reloadData()
        }
        
        return cell
    }
    
    @MainActor private func getNewTaskTableViewCell(_ tableView: UITableView,
                                                    cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellBasic = tableView.dequeueReusableCell(withIdentifier: "newCell", for: indexPath)
        guard let cell = cellBasic as? NewTaskTableViewCell else { return cellBasic }
        
        cell.separatorInset.right = .greatestFiniteMagnitude
        
        cell.newTaskButtonTappedHandler = { [weak self] in
            self?.newTaskButtonTappedHandler?()
        }
        
        return cell
    }
}
