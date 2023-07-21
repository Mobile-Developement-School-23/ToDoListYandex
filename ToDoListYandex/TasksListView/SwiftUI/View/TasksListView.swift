//
//  TasksListView.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 20.07.2023.
//

import SwiftUI

struct TasksListView: View {
    @Binding var items: [TodoItem]

    var body: some View {
        List() {
            let headerInfoCell = HeaderInfoCell(tasksDone: getDoneTasksCount())
            
            Section(header: headerInfoCell) {
                ForEach($items.sorted(by: { $0.id < $1.id })) { $item in
                    TaskCell(item: $item, done: item.done)
                        .onChange(of: item) { newValue in
                            updateElement(newValue)
                        }
                }
                NewTaskCell()
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color(.backPrimary))
        .listStyle(.insetGrouped)
    }
    
    func getDoneTasksCount() -> Int {
        items.filter { $0.done == true }.count
    }
    
    private func updateElement(_ item: TodoItem) {
        items.removeAll(where: { $0.id == item.id })
        items.append(item)
    }
}
