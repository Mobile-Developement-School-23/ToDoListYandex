//
//  SUITasksListView.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 20.07.2023.
//

import SwiftUI

struct SUITasksListView: View {
    
    @State private var data: [TodoItem] =
    [TodoItem(id: "2DFR-HTD4-89UI", text: "New task number 1", taskImportance: .important, deadlineDate: nil,
              done: false, creationDate: Date(timeIntervalSince1970: 1655700000), changeDate: nil, textColor: nil),
     TodoItem(id: "JJ81-N2S2-Y3YI", text: "Task 2 to check", taskImportance: .unimportant,
              deadlineDate: Date(timeIntervalSince1970: 1655790000), done: false,
              creationDate: Date(timeIntervalSince1970: 1655720000), changeDate: nil,
              textColor: UIColor.red.getColorCode()),
     TodoItem(id: "76G6-TTF9-KLAA", text: "Task number three to check two lines", taskImportance: .usual,
              deadlineDate: Date(timeIntervalSince1970: 1655890000), done: true,
              creationDate: Date(timeIntervalSince1970: 1655795000), changeDate: nil,
              textColor: UIColor.blue.getColorCode()),
     TodoItem(id: "81G9-TTF9-KLAA",
              text: """
              Task number four contains a lot of lines
              to check if app hide fourth task and more
              """,
              taskImportance: .unimportant,
              deadlineDate: Date(timeIntervalSince1970: 1655899000), done: true,
              creationDate: Date(timeIntervalSince1970: 1655705000), changeDate: nil,
              textColor: UIColor.blue.getColorCode())
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                TasksListView(items: $data)
                    .navigationTitle("Мои дела")
                    .navigationBarTitleDisplayMode(.large)
                NewTaskButton()
            }
        }
    }
}

struct SUITasksListView_Previews: PreviewProvider {
    static var previews: some View {
        SUITasksListView()
    }
}

struct NewTaskButton: View {
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "plus.circle.fill")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(Color(.colorBlue))
                .frame(width: 44, height: 44)
                .shadow(color: Color(.colorBlue.withAlphaComponent(0.3)), radius: 20)
        }
    }
}
