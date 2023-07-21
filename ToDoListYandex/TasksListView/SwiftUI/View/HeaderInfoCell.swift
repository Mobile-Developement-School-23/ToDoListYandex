//
//  HeaderInfoCell.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 20.07.2023.
//

import SwiftUI

struct HeaderInfoCell: View {
    var tasksDone = 0
    
    var body: some View {
        HStack {
            Text("Выполнено — \(tasksDone)")
                .foregroundColor(Color(.labelTertiary))
            Spacer()
            Button("Показать") {
                showDoneTasksList()
            }
            .fontWeight(.bold)
        }
        .padding(.bottom, 8)
        .textCase(.none)
        .font(.sfProTextRegular15)
    }
    
    func showDoneTasksList() {
        print("show")
    }
}
