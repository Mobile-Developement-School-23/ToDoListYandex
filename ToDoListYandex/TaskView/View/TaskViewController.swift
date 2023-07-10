//
//  ToDoListViewController.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 6/18/23.
//

import UIKit
import CocoaLumberjackSwift


class TaskViewController: UIViewController {
    
    let elementsScrollView = UIScrollView()
    let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    let colorPickerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.layer.cornerRadius = 16
        stackView.backgroundColor = .backSecondary
        stackView.spacing = 10
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 12)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    let colorPickerUpperStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    let colorButton: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = .labelPrimary
        view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        view.widthAnchor.constraint(equalToConstant: 30).isActive = true
        return view
    }()
    
    let colorLabel: UILabel = {
        let label = UILabel()
        label.text = "#000000FF"
        return label
    }()
    
    let colorPickerView: ColorPicker = {
        let colorPicker = ColorPicker()
        colorPicker.isHidden = true
        colorPicker.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return colorPicker
    }()
    
    let brightnessSliderView: UISlider = {
        let slider = UISlider()
        slider.isHidden = true
        slider.thumbTintColor = .backSecondary
        slider.tintColor = .colorBlue
        return slider
    }()
    
    let containerTextView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .backSecondary
        view.layer.cornerRadius = 16
        view.heightAnchor.constraint(equalToConstant: 120).isActive = true
        view.layoutMargins = UIEdgeInsets(top: 17, left: 16, bottom: 12, right: 12)
        view.isLayoutMarginsRelativeArrangement = true
        return view
    }()
    
    let taskTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Что надо сделать?"
        textView.textColor = .labelTertiary
        textView.font = .sfProTextRegular17
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        return textView
    }()
    
    let settingsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = .backSecondary
        stackView.layer.cornerRadius = 16
        stackView.spacing = 10
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 12)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    let importanceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    let importanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Важность"
        label.textColor = .labelPrimary
        label.font = .sfProTextRegular17
        return label
    }()
    
    let importanceSegmentControl: UISegmentedControl = {
        let imageUnimportant = UIImage(named: "unimportant")?.withRenderingMode(.alwaysOriginal)
        let usualTaskText = "нет"
        let imageImportant = UIImage(named: "important")?.withRenderingMode(.alwaysOriginal)
        
        var items: [Any] = [usualTaskText]
        if let imageUnimportant = imageUnimportant, let imageImportant = imageImportant {
            items = [imageUnimportant, usualTaskText, imageImportant]
        }
        let segmentControl = UISegmentedControl(items: items)
        segmentControl.selectedSegmentIndex = 1
        segmentControl.backgroundColor = .supportOverlay
        segmentControl.selectedSegmentTintColor = .backElevated
        segmentControl.setTitleTextAttributes([.font: UIFont.sfProTextMedium15], for: .normal)
        segmentControl.widthAnchor.constraint(equalToConstant: 150).isActive = true
        segmentControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
        return segmentControl
    }()
    
    let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .supportSeparator
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        return view
    }()
    
    let doDueStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.heightAnchor.constraint(equalToConstant: 42).isActive = true
        return stackView
    }()
    
    let doDueLeftStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()
    
    let doDueLabel: UILabel = {
        let label = UILabel()
        label.text = "Сделать до"
        label.textColor = .labelPrimary
        label.font = .sfProTextRegular17
        label.heightAnchor.constraint(equalToConstant: 22).isActive = true
        return label
    }()
    
    let doDueDateLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.font = .sfProTextSemibold13
        label.textColor = .colorBlue
        
        let date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        label.text = date.dayMonthYearDate
        label.heightAnchor.constraint(equalToConstant: 18).isActive = true
        return label
    }()
    
    let doDueSwitch: UISwitch = {
        let doSwitch = UISwitch()
        doSwitch.onTintColor = .colorGreen
        doSwitch.thumbTintColor = .backSecondary
        doSwitch.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return doSwitch
    }()
    
    let divider2: UIView = {
        let view = UIView()
        view.backgroundColor = .supportSeparator
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        view.isHidden = true
        return view
    }()
    
    let calendarView: UICalendarView = {
        let calendar = UICalendarView()
        calendar.isHidden = true
        calendar.tintColor = .colorBlue
        return calendar
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.backgroundColor = .backSecondary
        button.isEnabled = false
        button.titleLabel?.font = .sfProTextRegular17
        button.setTitle("Удалить", for: .normal)
        button.setTitleColor(.labelTertiary, for: .disabled)
        button.setTitleColor(.colorRed, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 56).isActive = true
        return button
    }()
    
    var presenter: TaskPresenterProtocol!
    var deleteTask: ((String) -> Void)?
    var addNewTask: ((TodoItem, Bool) -> Void)?
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        setupPresenter()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DDLogInfo("ToDoListViewController loaded")
        
        setupView()
        setupKeyboardSettings()
        configureNavBar()
        configureLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        recalculateTextViewHeight(taskTextView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardSettings()
    }
}
