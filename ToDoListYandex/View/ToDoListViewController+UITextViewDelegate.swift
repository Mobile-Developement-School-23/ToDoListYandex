//
//  ToDoListViewController+UITextViewDelegate.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 6/23/23.
//

import UIKit

extension ToDoListViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        _ = presenter.updateTextViewSettings(textView)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        _ = presenter.updateTextViewSettings(textView)
        
        recalculateTextViewHeight(textView)
    }
    
    func recalculateTextViewHeight(_ textView: UITextView) {
        let newSizeOfTextView = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        let heightGap = containerTextView.frame.height - textView.frame.height
        
        let constraint = containerTextView.constraints.filter { $0.firstAttribute == .height }.first
        
        constraint?.constant = max(newSizeOfTextView.height + heightGap, 120)
    }
}
