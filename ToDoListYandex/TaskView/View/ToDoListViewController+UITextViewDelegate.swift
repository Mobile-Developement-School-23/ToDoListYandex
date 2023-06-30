//
//  ToDoListViewController+UITextViewDelegate.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 6/23/23.
//

import UIKit
import CocoaLumberjackSwift

extension ToDoListViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        _ = presenter.textChangedTo(textView.text)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        _ = presenter.textChangedTo(textView.text)
        
        recalculateTextViewHeight(textView)
    }
    
    func recalculateTextViewHeight(_ textView: UITextView, isLandscape: Bool = false) {
        let newSizeOfTextView = textView.sizeThatFits(CGSize(width: textView.frame.size.width,
                                                             height: CGFloat.greatestFiniteMagnitude))
        let heightGap = containerTextView.frame.height - textView.frame.height
        
        let constraint = containerTextView.constraints.filter { $0.firstAttribute == .height }.first
        
        if isLandscape {
            let textViewHeight = min(self.view.frame.height, self.view.frame.width) -
            (self.navigationController?.navigationBar.frame.height ?? 0) - 55
            constraint?.constant = textViewHeight
        } else {
            constraint?.constant = max(newSizeOfTextView.height + heightGap, 120)
        }
        
        DDLogInfo("Text view height was changed to \(max(newSizeOfTextView.height + heightGap, 120))")
    }
}
