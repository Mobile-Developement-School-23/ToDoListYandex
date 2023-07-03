//
//  TaskTableViewCell.swift
//  ToDoListYandex
//
//  Created by Анастасия Горячевская on 27.06.2023.
//

import UIKit
import FileCache

class TaskTableViewCell: UITableViewCell {
    
    private let checkBoxView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = UIImage(named: "checkboxOff")
        view.heightAnchor.constraint(equalToConstant: 24).isActive = true
        view.widthAnchor.constraint(equalToConstant: 24).isActive = true
        return view
    }()
    
    private let textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private let taskTextLabel: UILabel = {
        let label = UILabel()
        label.text = "default"
        label.numberOfLines = 3
        label.textColor = .labelPrimary
        label.font = .sfProTextRegular17
        return label
    }()
    
    private let deadlineLabel: UILabel = {
        let label = UILabel()
        label.text = "default"
        label.textColor = .labelTertiary
        label.font = .sfProTextRegular15
        label.isHidden = true
        return label
    }()
    
    var doneButtonTappedHandler: (() -> Void)?
    
    private var text: String = ""
    private var done: Bool = false
    private var importance: TodoItem.TaskImportance = .usual
    private var deadline: Date?
    
    private var imageName: String {
        return done ? "checkboxOn" : (importance == .important ? "checkboxHighPriority" : "checkboxOff")
    }
    
    private var deadlineString: NSMutableAttributedString? {
        guard let deadline = deadline else { return nil }
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "calendar")?.withTintColor(.labelTertiary)
        let fullString = NSMutableAttributedString()
        fullString.append(NSAttributedString(attachment: imageAttachment))
        
        let dateString = deadline.dayMonthDate
        fullString.append(NSAttributedString(string: " " + dateString))
        
        return fullString
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCellView()
        
        self.backgroundColor = .backSecondary
        self.accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setInfo(taskText: String, importance: TodoItem.TaskImportance, done: Bool, deadline: Date? = nil) {
        self.text = taskText
        self.importance = importance
        self.done = done
        self.deadline = deadline
        
        setTaskText(taskText)
        setDoneButtonImage()
        setDeadline()
    }
    
    private func configureCellView() {
        configureCheckbox()
        configureTextStackView()
        configureCheckBoxView()
    }
    
    private func configureCheckbox() {
        contentView.addSubview(checkBoxView)
        
        checkBoxView.translatesAutoresizingMaskIntoConstraints = false
        checkBoxView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        checkBoxView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    private func configureTextStackView() {
        contentView.addSubview(textStackView)
        
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        textStackView.leadingAnchor.constraint(equalTo: checkBoxView.trailingAnchor, constant: 12).isActive = true
        textStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        textStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        textStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        
        fillTextStackView()
    }
    
    private func fillTextStackView() {
        textStackView.addArrangedSubview(taskTextLabel)
        textStackView.addArrangedSubview(deadlineLabel)
    }
    
    private func configureCheckBoxView() {
        let checkboxTap = UITapGestureRecognizer(target: self, action: #selector(checkboxTapped))
        checkBoxView.isUserInteractionEnabled = true
        checkBoxView.addGestureRecognizer(checkboxTap)
    }
    
    @objc private func checkboxTapped() {
        doneChanged()
    }
    
    private func doneChanged() {
        doneButtonTappedHandler?()
        done = !done
        setDoneButtonImage()
    }
    
    private func setTaskText(_ text: String, isStrikethrough: Bool = false) {
        let attributes: [NSAttributedString.Key: Any] =
        isStrikethrough ? [.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                           .strikethroughColor: UIColor.labelTertiary,
                           .foregroundColor: UIColor.labelTertiary] : [:]
        
        let attributedText = NSAttributedString(
            string: text,
            attributes: attributes
        )
        
        taskTextLabel.attributedText = importance == .important ? textWithIcon(with: attributes) : attributedText
    }
    
    private func textWithIcon(with attributes: [NSAttributedString.Key: Any]) -> NSMutableAttributedString {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: "important")?.withRenderingMode(.alwaysOriginal)
        let fullString = NSMutableAttributedString()
        fullString.append(NSAttributedString(attachment: imageAttachment))
        fullString.append(NSAttributedString(string: " " + text, attributes: attributes))
        
        return fullString
    }
    
    private func setDoneButtonImage() {
        checkBoxView.image = UIImage(named: imageName)
        setTaskText(text, isStrikethrough: imageName == "checkboxOn")
    }
    
    private func setDeadline() {
        deadlineLabel.isHidden = true
        guard deadline != nil else { return }
        
        deadlineLabel.isHidden = false
        deadlineLabel.attributedText = deadlineString
    }
}
