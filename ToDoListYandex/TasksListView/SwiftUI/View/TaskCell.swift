//
//  TaskCell.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 20.07.2023.
//

import SwiftUI

struct TaskCell: View {
    @Binding var item: TodoItem
    @State var done: Bool
    
    var body: some View {
        HStack {
            DoneImageView(done: $done, importance: item.taskImportance)
                .onChange(of: done) { newValue in
                    let newItem = TodoItem(id: item.id,
                                           text: item.text,
                                           taskImportance: item.taskImportance,
                                           deadlineDate: item.deadlineDate,
                                           done: newValue,
                                           creationDate: item.creationDate,
                                           changeDate: item.changeDate,
                                           textColor: item.hexColor)
                    item = newItem
                }
            VStack(alignment: .leading) {
                MainTextView(importance: item.taskImportance, text: item.text)
                if let deadlineDateString = item.deadlineDate?.dayMonthDate {
                    Label(deadlineDateString, systemImage: "calendar")
                        .font(.sfProTextRegular15)
                        .foregroundColor(Color(.labelTertiary))
                        .labelStyle(.titleAndIcon)
                }
            }
            .padding(EdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 10))
            Spacer()
            Image(systemName: "chevron.forward")
                .foregroundColor(Color(.colorGray))
        }
    }
}

struct DoneImageView: View {
    @Binding var done: Bool
    var importance: TodoItem.TaskImportance = .usual
    
    var body: some View {
        Image(getImageName()).onTapGesture {
            doneButtonTapped()
        }
    }
    
    private func getImageName() -> String {
        var imageName = "checkboxOn"
        
        if !done {
            if importance == .important {
                imageName = "checkboxHighPriority"
            } else {
                imageName = "checkboxOff"
            }
        }
        return imageName
    }
    
    private func doneButtonTapped() {
        done = !done
    }
}


struct MainTextView: View {
    let importance: TodoItem.TaskImportance
    let text: String
    
    var body: some View {
        switch importance {
        case .unimportant:
            Label(text, image: "unimportant")
                .font(.sfProTextRegular17)
                .foregroundColor(Color(.labelPrimary))
                .labelStyle(.titleAndIcon)
                .lineLimit(3)
        case .usual:
            Text(text)
                .font(.sfProTextRegular17)
                .foregroundColor(Color(.labelPrimary))
                .lineLimit(3)
        case .important:
            Label(text, image: "important")
                .font(.sfProTextRegular17)
                .foregroundColor(Color(.labelPrimary))
                .labelStyle(.titleAndIcon)
                .lineLimit(3)
        }
        
//        if importance == .important {
//            Label(text, image: "important")
//                .font(.sfProTextRegular17)
//                .foregroundColor(Color(.labelPrimary))
//                .labelStyle(.titleAndIcon)
//                .lineLimit(3)
//        } else {
//            Text(text)
//                .font(.sfProTextRegular17)
//                .foregroundColor(Color(.labelPrimary))
//                .lineLimit(3)
//        }
    }
}
