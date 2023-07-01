//
//  TransitionAnimator.swift
//  ToDoListYandex
//
//  Created by Анастасия Горячевская on 29.06.2023.
//

import UIKit

class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration = 0.5
    
    private let cellImageViewRect: CGRect
    
    init?(cellRect: CGRect?) {
        guard let cellImageViewRect = cellRect else { return nil }
        self.cellImageViewRect = cellImageViewRect
    }
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        
        containerView.addSubview(toView)
        
        toView.frame = cellImageViewRect
        
        UIView.animate(
            withDuration: duration,
            animations: {
                toView.transform = CGAffineTransform.identity
            },
            completion: { _ in
                transitionContext.completeTransition(true)
            }
        )
    }
}
