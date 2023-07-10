//
//  TasksListViewController.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 26.06.2023.
//

import UIKit
import CocoaLumberjackSwift


class TasksListViewController: UIViewController {
    
    let tasksTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 52, bottom: 0, right: 0)
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "taskCell")
        tableView.register(TasksListInfoViewCell.self, forCellReuseIdentifier: "infoCell")
        tableView.register(NewTaskTableViewCell.self, forCellReuseIdentifier: "newCell")
        return tableView
    }()
    
    private let addNewTaskView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus.circle.fill")?.withRenderingMode(.alwaysTemplate)
        
        imageView.layer.shadowColor = UIColor.colorBlue.cgColor.copy(alpha: 0.3)
        imageView.layer.shadowOffset = CGSize(width: 0, height: 8)
        imageView.layer.shadowRadius = 20
        imageView.layer.shadowOpacity = 1.0
        imageView.layer.masksToBounds = false
        
        imageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        return imageView
    }()
    
    private let tasksDataSource = TasksTableViewDataSource()
    private let tasksDelegate = TasksTableViewDelegate()
    
    var cellRect: CGRect?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DDLogInfo("Tasks List View loaded")
        
        tasksDelegate.dataSource = tasksDataSource
        tasksDelegate.view = self
        tasksDataSource.view = self
        tasksTableView.dataSource = tasksDataSource
        tasksTableView.delegate = tasksDelegate
        
        configureView()
        configureNavBar()
        configureTableView()
        configureAddNewTaskView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureView() {
        view.backgroundColor = .backPrimary
    }
    
    private func configureNavBar() {
        navigationItem.title = "Мои дела"
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.sfProTextSemibold34]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.sfProTextSemibold17]
    }
    
    private func configureTableView() {
        view.addSubview(tasksTableView)
        
        tasksDataSource.newTaskButtonTappedHandler = { [weak self] in
            self?.newTaskViewTapped()
        }
        
        tasksDelegate.cellTappedHandler = { [weak self] indexPath in
            let rectInTableView = self?.tasksTableView.rectForRow(at: indexPath)
            let rectInSuperview = self?.tasksTableView.convert(rectInTableView!, to: self?.view)
            self?.cellRect = rectInSuperview
            
            self?.transitionToTaskVC(withTodoItem: self?.tasksDataSource.task(at: indexPath.row - 1))
        }
        
        tasksTableView.translatesAutoresizingMaskIntoConstraints = false
        tasksTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tasksTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                constant: 16).isActive = true
        tasksTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                 constant: -16).isActive = true
        tasksTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func configureAddNewTaskView() {
        view.addSubview(addNewTaskView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(newTaskViewTapped))
        addNewTaskView.isUserInteractionEnabled = true
        addNewTaskView.addGestureRecognizer(tapGestureRecognizer)
        
        addNewTaskView.translatesAutoresizingMaskIntoConstraints = false
        addNewTaskView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addNewTaskView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                               constant: -20).isActive = true
    }
    
    @objc private func newTaskViewTapped() {
        DDLogInfo("New Task Button Tapped")
        transitionToTaskVC()
    }
    
    func transitionToTaskVC(withTodoItem todoItem: TodoItem? = nil) {
        let taskViewController = TaskViewController()
        if let todoItem = todoItem {
            _ = taskViewController.presenter.fillTaskInfo(todoItem)
        }
        
        taskViewController.deleteTask = { id in
            self.tasksDataSource.deleteTask(byId: id)
        }
        
        taskViewController.addNewTask = { task, isNewTask in
            if isNewTask {
                self.tasksDataSource.addTask(task)
            } else {
                self.tasksDataSource.updateTask(task)
            }
        }
        
        let navController = UINavigationController(rootViewController: taskViewController)
        navController.transitioningDelegate = self
        
        self.present(navController, animated: true, completion: nil)
    }
}
