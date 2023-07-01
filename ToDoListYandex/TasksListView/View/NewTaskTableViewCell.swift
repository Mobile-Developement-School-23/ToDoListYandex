//
//  NewTaskTableViewCell.swift
//  ToDoListYandex
//
//  Created by Анастасия Горячевская on 28.06.2023.
//

import UIKit

class NewTaskTableViewCell: UITableViewCell {
    
    let newLabel: UILabel = {
        let label = UILabel()
        label.text = "Новое"
        label.font = .sfProTextRegular17
        label.textColor = .labelTertiary
        return label
    }()
    
    var newTaskButtonTappedHandler: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCellView()
        setNewLabelTarget()
        
        self.backgroundColor = .backSecondary
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setNewLabelTarget() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(labelNewTapped))
        newLabel.isUserInteractionEnabled = true
        newLabel.addGestureRecognizer(tap)
    }
    
    private func configureCellView() {
        contentView.addSubview(newLabel)
        
        newLabel.translatesAutoresizingMaskIntoConstraints = false
        newLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 52).isActive = true
        newLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 17).isActive = true
        newLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -17).isActive = true
        newLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
    }
    
    @objc private func labelNewTapped() {
        newTaskButtonTappedHandler?()
    }
}
