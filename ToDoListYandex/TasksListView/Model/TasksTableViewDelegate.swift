//
//  TasksTableViewDelegate.swift
//  ToDoListYandex
//
//  Created by Анастасия Горячевская on 29.06.2023.
//

import UIKit

class TasksTableViewDelegate: NSObject {
    var dataSource: TasksTableViewDataSource?
    
    var cellTappedHandler: ((IndexPath) -> Void)?
    
    weak var view: TasksListViewController?
}

extension TasksTableViewDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let dataSource = dataSource else { return nil }
        
        if indexPath.row == 0 || indexPath.row == dataSource.numberOfTasks() + 1 { return nil }
        
        let doneAction = UIContextualAction(style: .normal, title: nil) { (_, _, completion) in
            self.dataSource?.updateTaskDone(at: indexPath.row - 1)
            
            tableView.reloadData()
            completion(true)
        }
        doneAction.backgroundColor = .colorGreen
        doneAction.image = UIImage(systemName: "checkmark.circle.fill")
        
        return UISwipeActionsConfiguration(actions: [doneAction])
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let dataSource = dataSource else { return nil }
        
        if indexPath.row == 0 || indexPath.row == dataSource.numberOfTasks() + 1 { return nil }
        
        let infoAction = UIContextualAction(style: .normal, title: nil) { _, _, _ in
            print("info")
        }
        infoAction.image = UIImage(systemName: "info.circle.fill")
        infoAction.backgroundColor = .colorGrayLight
        
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completion) in
            _ = dataSource.removeTask(at: indexPath.row - 1)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        deleteAction.backgroundColor = .colorRed
        
        return UISwipeActionsConfiguration(actions: [deleteAction, infoAction])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let dataSource = dataSource else { return }
        
        var size = CGSize(width: 0, height: 0)
        if indexPath.row == 1 || indexPath.row == dataSource.numberOfTasks() + 1 {
            size = CGSize(width: 16, height: 16)
        }
        
        var rectCorner: UIRectCorner = [UIRectCorner.topLeft, UIRectCorner.topRight]
        if indexPath.row == dataSource.numberOfTasks() + 1 {
            rectCorner = [.bottomLeft, UIRectCorner.bottomRight]
            if dataSource.numberOfTasks() == 0 {
                rectCorner = [UIRectCorner.topLeft, UIRectCorner.topRight,
                              UIRectCorner.bottomLeft, UIRectCorner.bottomRight]
            }
        }
        
        let maskPath = UIBezierPath(roundedRect: cell.bounds,
                                    byRoundingCorners: rectCorner,
                                    cornerRadii: size)
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        cell.layer.mask = shape
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard indexPath.row > 0 else { return }
        cellTappedHandler?(indexPath)
    }
    
    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        
        let taskViewController = ToDoListViewController()
        if let task = dataSource?.task(at: indexPath.row - 1) {
            _ = taskViewController.presenter.fillTaskInfo(task)
        }
        
        let identifier = "\(indexPath.row - 1)" as NSString

        return UIContextMenuConfiguration(identifier: identifier,
                                          previewProvider: { taskViewController },
                                          actionProvider: nil)
    }
    
    func tableView(_ tableView: UITableView,
                   willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration,
                   animator: UIContextMenuInteractionCommitAnimating) {
        guard let identifier = configuration.identifier as? String,
              let index = Int(identifier),
              let task = dataSource?.task(at: index)
        else { return  }
        
        animator.addAnimations {
            self.view?.transitionToTaskVC(withTodoItem: task)
        }
    }
}
