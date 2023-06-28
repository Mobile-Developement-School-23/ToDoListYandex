//
//  TasksListViewController+TransitionDelegate.swift
//  ToDoListYandex
//
//  Created by Анастасия Горячевская on 29.06.2023.
//

import UIKit

extension TasksListViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        TransitionAnimator(cellRect: cellRect)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        nil
    }
}
