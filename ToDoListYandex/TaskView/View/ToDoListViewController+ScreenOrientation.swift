//
//  ToDoListViewController+ScreenOrientation.swift
//  ToDoListYandex
//
//  Created by Анастасия Горячевская on 30.06.2023.
//

import UIKit

extension ToDoListViewController {
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        displayAllElementsExeptTextView(!UIDevice.current.orientation.isLandscape)
        recalculateTextViewHeight(taskTextView, isLandscape: UIDevice.current.orientation.isLandscape)
    }
    
    private func displayAllElementsExeptTextView(_ display: Bool) {
        colorPickerStackView.isHidden = !display
        settingsStackView.isHidden = !display
        deleteButton.isHidden = !display
    }
}
