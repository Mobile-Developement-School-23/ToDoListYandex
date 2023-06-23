//
//  ToDoListViewController.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 6/18/23.
//

import UIKit

class ToDoListViewController: UIViewController, ToDoListViewControllerProtocol {
    
    private let elementsScrollView = UIScrollView()
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private let colorPickerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.layer.cornerRadius = 16
        stackView.backgroundColor = .backSecondary
        stackView.spacing = 10
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 12)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private let colorPickerUpperStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    private let colorButton: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = .labelPrimary
        view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        view.widthAnchor.constraint(equalToConstant: 30).isActive = true
        return view
    }()
    
    private let colorLabel: UILabel = {
        let label = UILabel()
        label.text = "#000000FF"
        return label
    }()
    
    private let colorPickerView: ColorPicker = {
        let colorPicker = ColorPicker()
        colorPicker.isHidden = true
        colorPicker.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return colorPicker
    }()
    
    private let brightnessSliderView: UISlider = {
        let slider = UISlider()
        slider.isHidden = true
        slider.thumbTintColor = .backSecondary
        slider.tintColor = .colorBlue
        slider.addTarget(self, action: #selector(changedBrightnessSliderValue), for: .valueChanged)
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
    
    private let taskTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Что надо сделать?"
        textView.textColor = .labelTertiary
        textView.font = .sfProTextRegular17
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        return textView
    }()
    
    private let settingsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = .backSecondary
        stackView.layer.cornerRadius = 16
        stackView.spacing = 10
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 12)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private let importanceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let importanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Важность"
        label.textColor = .labelPrimary
        label.font = .sfProTextRegular17
        return label
    }()
    
    private let importanceSegmentControl: UISegmentedControl = {
        let imageUnimportant = UIImage(named: "unimportant")?.withRenderingMode(.alwaysOriginal)
        let usualTaskText = "нет"
        let imageImportant = UIImage(named: "important")?.withRenderingMode(.alwaysOriginal)
        let segmentControl = UISegmentedControl(items: [imageUnimportant, usualTaskText, imageImportant])
        segmentControl.selectedSegmentIndex = 2
        segmentControl.addTarget(self, action: #selector(importanceSegmentControlValueChanged(_:)), for: .valueChanged)
        segmentControl.backgroundColor = .supportOverlay
        segmentControl.selectedSegmentTintColor = .backElevated
        segmentControl.setTitleTextAttributes([.font: UIFont.sfProTextMedium15], for: .normal)
        segmentControl.widthAnchor.constraint(equalToConstant: 150).isActive = true
        segmentControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
        return segmentControl
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .supportSeparator
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        return view
    }()
    
    private let doDueStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.heightAnchor.constraint(equalToConstant: 42).isActive = true
        return stackView
    }()
    
    private let doDueLeftStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()
    
    private let doDueLabel: UILabel = {
        let label = UILabel()
        label.text = "Сделать до"
        label.textColor = .labelPrimary
        label.font = .sfProTextRegular17
        label.heightAnchor.constraint(equalToConstant: 22).isActive = true
        return label
    }()
    
    private let doDueDateLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.font = .sfProTextSemibold13
        label.textColor = .colorBlue
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        let date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        label.text = dateFormatter.string(from: date)
        label.heightAnchor.constraint(equalToConstant: 18).isActive = true
        return label
    }()
    
    private let doDueSwitch: UISwitch = {
        let doSwitch = UISwitch()
        doSwitch.onTintColor = .colorGreen
        doSwitch.thumbTintColor = .backSecondary
        doSwitch.addTarget(self, action: #selector(doDueSwitchChanged(_:)), for: .valueChanged)
        doSwitch.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return doSwitch
    }()
    
    private let divider2: UIView = {
        let view = UIView()
        view.backgroundColor = .supportSeparator
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        view.isHidden = true
        return view
    }()
    
    private let calendarView: UICalendarView = {
        let calendar = UICalendarView()
        calendar.isHidden = true
        calendar.tintColor = .colorBlue
        return calendar
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.backgroundColor = .backSecondary
        button.isEnabled = false
        button.titleLabel?.font = .sfProTextRegular17
        button.setTitle("Удалить", for: .normal)
        button.setTitleColor(.labelTertiary, for: .disabled)
        button.setTitleColor(.colorRed, for: .normal)
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 56).isActive = true
        return button
    }()
    
    var presenter: ToDoListPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPresenter()
        setupView()
        setupKeyboardSettings()
        
        configureNavBar()
        configureLayout()
        configureDoDueDateLabel()
        configureColorButton()
        configureCalendarView()
        
        colorPickerView.delegate = presenter as? ColorPickerDelegate
        taskTextView.delegate = self
        
        presenter.loadTaskInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        recalculateTextViewHeight(taskTextView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardSettings()
    }
    
    private func setupView() {
        view.backgroundColor = .backPrimary
    }
    
    private func setupPresenter() {
        let presenter = ToDoListPresenter()
        presenter.view = self
        self.presenter = presenter
    }
    
    private func setupKeyboardSettings() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: self.view.window)
    }
    
    private func removeKeyboardSettings() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: self.view.window)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            view.frame.size.height -= keyboardSize.height
        }
    }
    @objc func keyboardWillHide(sender: NSNotification) {
        if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            view.frame.size.height += keyboardSize.height
        }
    }
    
    func configureNavBar() {
        navigationItem.title = "Дело"
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.sfProTextSemibold17]
        
        let cancelBarButtonItem = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(tappedCancelButton))
        cancelBarButtonItem.setTitleTextAttributes([.font: UIFont.sfProTextRegular17, .foregroundColor: UIColor.colorBlue],
                                                   for: .normal)
        
        let saveBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(tappedSaveButton))
        saveBarButtonItem.setTitleTextAttributes([.font: UIFont.sfProTextMedium17, .foregroundColor: UIColor.colorBlue],
                                                 for: .normal)
        
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItem = saveBarButtonItem
    }
    
    private func configureLayout() {
        configureScrollView()
        configureContentStackView()
        configureStackElements()
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
        contentStackView.leadingAnchor.constraint(equalTo: elementsScrollView.leadingAnchor, constant: 16).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: elementsScrollView.trailingAnchor, constant: -16).isActive = true
        contentStackView.bottomAnchor.constraint(equalTo: elementsScrollView.bottomAnchor, constant: -16).isActive = true
        contentStackView.widthAnchor.constraint(equalTo: elementsScrollView.widthAnchor, constant: -32).isActive = true
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
    
    @objc private func tappedCancelButton() {
        print("Отменить")
    }
    
    @objc private func tappedSaveButton() {
        presenter.saveTask()
    }
    
    @objc private func tappedColorPickerButton() {
        presenter.colorPickerButtonTapped(isPickerDisplayed: !colorPickerView.isHidden)
    }
    
    @objc private func changedBrightnessSliderValue(_ sender: UISlider) {
        presenter.brightnessSliderChanged(value: Double(sender.value))
    }
    
    @objc private func importanceSegmentControlValueChanged(_ sender: UISegmentedControl) {
        _ = presenter.setImportanceSegment(sender.selectedSegmentIndex)
    }
    
    @objc private func doDueSwitchChanged(_ sender: UISwitch) {
        _ = presenter.doDueSwitchActivate(sender.isOn)
    }
    
    @objc private func doDueDateLabelTapped() {
        _ = presenter.doDueDateLabelTouched(isCalendarHidden: calendarView.isHidden)
    }
    
    @objc private func deleteButtonTapped() {
        presenter.deleteElements()
    }
    
    func activateDoDueSwitch(_ activate: Bool) {
        doDueSwitch.isOn = activate
    }
    
    func displayCalendar(_ display: Bool) {
        divider2.isHidden = !display
        calendarView.isHidden = !display
    }
    
    func startCalendarAnimation() {
        calendarView.alpha = 0.0
        UIView.animate(withDuration: 0.3) {
            self.calendarView.alpha = 1.0
            self.calendarView.transform = .identity
        }
    }
    
    func updateTaskText(_ text: String, textColor: UIColor?, isResignFirstResponder: Bool) {
        taskTextView.text = text
        taskTextView.textColor = textColor ?? taskTextView.textColor
        if isResignFirstResponder {
            taskTextView.resignFirstResponder()
        }
        recalculateTextViewHeight(taskTextView)
    }
    
    func updateImportanceControl(_ segment: Int) {
        importanceSegmentControl.selectedSegmentIndex = segment
    }
    
    func displayDoDueDateLabel(_ display: Bool) {
        doDueDateLabel.isHidden = !display
    }
    
    func updateDeleteButton(setActive: Bool) {
        deleteButton.isEnabled = setActive
    }
    
    func updateDoDueDateLabelValue(_ doDueDateString: String) {
        doDueDateLabel.text = doDueDateString
    }
    
    func changePickerViewButtonColor(_ color: UIColor) {
        colorButton.backgroundColor = color
    }
    
    func changeColorCodeText(_ text: String) {
        colorLabel.text = text
    }
    
    func displayColorPickerView(_ display: Bool) {
        colorPickerView.isHidden = !display
        brightnessSliderView.isHidden = !display
    }
    
    func startColorPickerAnimation() {
        colorPickerView.alpha = 0.0
        UIView.animate(withDuration: 0.3) {
            self.colorPickerView.alpha = 1.0
            self.colorPickerView.transform = .identity
        }
    }
    
    func setSliderValue(_ value: Float) {
        brightnessSliderView.value = value
    }
}