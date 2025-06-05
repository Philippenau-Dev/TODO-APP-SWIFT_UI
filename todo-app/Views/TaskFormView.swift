//
//  TaskFormView.swift
//  todo-app
//
//  Created by Premiersoft on 6/4/25.
//

import SwiftUI

struct TaskFormView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var task: TaskModel?
    @State private var title: String = ""
    
    var onSave: (TaskCreateDTO) -> Void
    
    var body: some View {
        Text(task == nil ? "Nova Tarefa" : "Editar Tarefa")
            .padding(.top)
        ZStack {
            Form {
                TextField("Título da tarefa", text: $title)
                    .padding(12)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
            .scrollContentBackground(.hidden)
        }
        .onAppear {
            title = task?.title ?? ""
        }
        HStack {
            Spacer()
            Button(action:{
                dismiss()
            }) {
                Text("Cancelar")
            }
            .font(.headline)
            .padding()
            .foregroundStyle(.blue)
            Spacer()
            Button(action: {
                let newTask = TaskCreateDTO(
                    title: title,
                    done: task?.done ?? false
                )
                onSave(newTask)
                dismiss()
            }) {
                Text("Salvar")
            }
            .font(.headline)
            .padding()
            .background(.blue)
            .foregroundStyle(.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
            Spacer()
        }
      
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var mockTask: TaskModel? = TaskModel(id: nil, title: "Tarefa", done: true)

        var body: some View {
            TaskFormView(task: $mockTask) { updatedTask in
                print("Tarefa salva: \(updatedTask)")
            }
        }
    }

    return PreviewWrapper()
}
