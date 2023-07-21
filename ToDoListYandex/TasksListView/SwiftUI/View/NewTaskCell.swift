//
//  NewTaskCell.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 21.07.2023.
//

import SwiftUI

struct NewTaskCell: View {
    var body: some View {
        HStack() {
            Image("checkboxOff")
                .hidden()
            Text("Новое")
                .font(.sfProTextRegular17)
                .foregroundColor(Color(.labelTertiary))
        }
        .padding(EdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 10))
    }
}

struct NewTaskCell_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskCell()
    }
}
