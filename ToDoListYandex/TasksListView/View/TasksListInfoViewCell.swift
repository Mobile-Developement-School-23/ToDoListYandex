//
//  TasksListInfoViewCell.swift
//  ToDoListYandex
//
//  Created by Анастасия Горячевская on 28.06.2023.
//

import UIKit

class TasksListInfoViewCell: UITableViewCell {
    
    private let tasksDoneLabel: UILabel = {
        let label = UILabel()
        label.text = "Выполнено - 0"
        label.textColor = .labelTertiary
        label.font = .sfProTextRegular15
        return label
    }()
    
    private let showButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.colorBlue, for: .normal)
        button.titleLabel?.font = .sfProTextMedium15
        button.setTitle("Показать", for: .normal)
        button.contentHorizontalAlignment = .right
        return button
    }()
    
    var showDoneTasksTappedHandler: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCellView()
        
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDoneNumber(_ done: Int) {
        tasksDoneLabel.text = "Выполнено - \(done)"
    }
    
    private func configureCellView() {
        configureTasksDoneLabel()
        configureShowButton()
    }
    
    private func configureTasksDoneLabel() {
        contentView.addSubview(tasksDoneLabel)
        
        tasksDoneLabel.translatesAutoresizingMaskIntoConstraints = false
        tasksDoneLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        tasksDoneLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        tasksDoneLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
    }
    
    private func configureShowButton() {
        contentView.addSubview(showButton)
        
        showButton.addTarget(self, action: #selector(showDoneTasksTapped), for: .touchUpInside)
        
        showButton.translatesAutoresizingMaskIntoConstraints = false
        showButton.leadingAnchor.constraint(equalTo: tasksDoneLabel.trailingAnchor, constant: 16).isActive = true
        showButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        showButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
        showButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
    }
    
    @objc private func showDoneTasksTapped() {
        showDoneTasksTappedHandler?()
    }
    
}
