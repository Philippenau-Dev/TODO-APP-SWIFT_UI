//
//  ContentView.swift
//  todo-app
//
//  Created by Premiersoft on 6/4/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TaskViewModel()
    @State private var isShowingForm = false
    @State private var isShowingDelete = false
    @State private var selectedTask: TaskModel? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Bucando tarefas...")
                } else {
                    List($viewModel.tasks) { $task in
                        HStack {
                            Button(action: {
                                let doneState = !task.done
                                task.done.toggle()
                               
                                viewModel.editTask(
                                    taskId: task.id ?? "",
                                    task: TaskCreateDTO(title: task.title,done: doneState)
                                )
                            }) {
                                HStack {
                                    Image(
                                        systemName: task.done
                                        ? "checkmark.square"
                                        : "square"
                                    )
                                    Text(task.title)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Spacer()
                            
                            Button(action: {
                                selectedTask = task
                                isShowingForm = true
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundStyle(.blue)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Button(action: {
                                selectedTask = task
                                isShowingDelete = true
                            }) {
                                Image(systemName: "trash")
                                    .foregroundStyle(.red)
                            }
                            .padding(.leading, 12)
                            .buttonStyle(PlainButtonStyle())
                        }
                        .listRowBackground(Color.white)
                    }
                    .listStyle(.sidebar)
                }
            }
            .navigationTitle("Minhas Tarefas")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.white, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("Plus")
                        selectedTask = nil
                        isShowingForm = true
                    }){
                        Image(systemName: "plus")
                    }
                }
                
            }
            .alert("Tem certeza que deseja excluir?", isPresented: $isShowingDelete) {
                Button("Deletar", role: .destructive) {
                    if let task = selectedTask {
                        viewModel.deleteTask(taskId: task.id ?? "")
                    }
                }
                Button("Cancelar", role: .cancel) {
                    isShowingDelete = false
                }
            }
            .sheet(isPresented: $isShowingForm) {
                TaskFormView(task: $selectedTask) { newTask in
                    if let taskId = selectedTask?.id {
                        viewModel.editTask(taskId: taskId, task: newTask)
                    } else {
                        viewModel.createTask(task: newTask)
                    }
                }
                .presentationDetents([.fraction(0.3)])
            }
            .onAppear {
                viewModel.getTasks()
            }
        }
    }
}

#Preview {
    ContentView()
}
