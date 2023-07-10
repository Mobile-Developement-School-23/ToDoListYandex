//
//  ToDoListViewController+ConfigureView.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 30.06.2023.
//

import UIKit
import CocoaLumberjackSwift

extension TaskViewController {
    
    func setupView() {
        view.backgroundColor = .backPrimary
        
        colorPickerView.delegate = presenter as? ColorPickerDelegate
        taskTextView.delegate = self
    }
    
    func setupPresenter() {
        let presenter = TaskPresenter()
        presenter.view = self
        self.presenter = presenter
    }
    
    func setupKeyboardSettings() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: self.view.window)
    }
    
    func removeKeyboardSettings() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification,
                                                  object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification,
                                                  object: self.view.window)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            view.frame.size.height -= keyboardSize.height
        }
        DDLogInfo("Keyboard was showed")
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            view.frame.size.height += keyboardSize.height
        }
        DDLogInfo("Keyboard was hided")
    }
    
    func configureNavBar() {
        navigationItem.title = "Дело"
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.sfProTextSemibold17]
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let cancelBarButtonItem = UIBarButtonItem(title: "Отменить", style: .plain,
                                                  target: self, action: #selector(tappedCancelButton))
        cancelBarButtonItem.setTitleTextAttributes([.font: UIFont.sfProTextRegular17,
                                                    .foregroundColor: UIColor.colorBlue],
                                                   for: .normal)
        
        let saveBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done,
                                                target: self, action: #selector(tappedSaveButton))
        saveBarButtonItem.setTitleTextAttributes([.font: UIFont.sfProTextMedium17, .foregroundColor: UIColor.colorBlue],
                                                 for: .normal)
        
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItem = saveBarButtonItem
    }
    
    func configureLayout() {
        configureScrollView()
        configureContentStackView()
        configureStackElements()
        
        configureDoDueDateLabel()
        configureColorButton()
        configureCalendarView()
        
        configureTargets()
    }
    
    private func configureScrollView() {
        view.addSubview(elementsScrollView)
        
        let margins = view.layoutMarginsGuide
        elementsScrollView.translatesAutoresizingMaskIntoConstraints = false
        elementsScrollView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        elementsScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        elementsScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        elementsScrollView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
    private func configureContentStackView() {
        elementsScrollView.addSubview(contentStackView)
        
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.topAnchor.constraint(equalTo: elementsScrollView.topAnchor, constant: 16).isActive = true
        contentStackView.leadingAnchor.constraint(equalTo: elementsScrollView.leadingAnchor,
                                                  constant: 16).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: elementsScrollView.trailingAnchor,
                                                   constant: -16).isActive = true
        contentStackView.bottomAnchor.constraint(equalTo: elementsScrollView.bottomAnchor,
                                                 constant: -16).isActive = true
        contentStackView.widthAnchor.constraint(equalTo: elementsScrollView.widthAnchor,
                                                constant: -32).isActive = true
    }
    
    private func configureStackElements() {
        contentStackView.addArrangedSubview(colorPickerStackView)
        contentStackView.addArrangedSubview(containerTextView)
        contentStackView.addArrangedSubview(settingsStackView)
        contentStackView.addArrangedSubview(deleteButton)
        
        colorPickerStackView.addArrangedSubview(colorPickerUpperStackView)
        colorPickerStackView.addArrangedSubview(colorPickerView)
        colorPickerStackView.addArrangedSubview(brightnessSliderView)
        
        colorPickerUpperStackView.addArrangedSubview(colorButton)
        colorPickerUpperStackView.addArrangedSubview(colorLabel)
        
        containerTextView.addArrangedSubview(taskTextView)
        
        settingsStackView.addArrangedSubview(importanceStackView)
        settingsStackView.addArrangedSubview(divider)
        settingsStackView.addArrangedSubview(doDueStackView)
        settingsStackView.addArrangedSubview(divider2)
        settingsStackView.addArrangedSubview(calendarView)
        
        importanceStackView.addArrangedSubview(importanceLabel)
        importanceStackView.addArrangedSubview(importanceSegmentControl)
        
        doDueStackView.addArrangedSubview(doDueLeftStackView)
        doDueStackView.addArrangedSubview(doDueSwitch)
        
        doDueLeftStackView.addArrangedSubview(doDueLabel)
        doDueLeftStackView.addArrangedSubview(doDueDateLabel)
    }
    
    private func configureDoDueDateLabel() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(doDueDateLabelTapped))
        doDueDateLabel.isUserInteractionEnabled = true
        doDueDateLabel.addGestureRecognizer(tap)
    }
    
    private func configureColorButton() {
        let colorButtonTap = UITapGestureRecognizer(target: self, action: #selector(tappedColorPickerButton))
        colorButton.isUserInteractionEnabled = true
        colorButton.addGestureRecognizer(colorButtonTap)
    }
    
    private func configureCalendarView() {
        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = selection
    }
    
    private func configureTargets() {
        brightnessSliderView.addTarget(self, action: #selector(changedBrightnessSliderValue), for: .valueChanged)
        importanceSegmentControl.addTarget(self, action:
                                            #selector(importanceSegmentControlValueChanged(_:)), for: .valueChanged)
        doDueSwitch.addTarget(self, action: #selector(doDueSwitchChanged(_:)), for: .valueChanged)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
}
