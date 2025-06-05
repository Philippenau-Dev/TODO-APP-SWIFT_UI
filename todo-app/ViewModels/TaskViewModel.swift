//
//  TaskViewModel.swift
//  todo-app
//
//  Created by Premiersoft on 6/4/25.
//

import SwiftUI

class TaskViewModel: ObservableObject {
    @Published var tasks: [TaskModel] = []
    @Published var isLoading = false
    @Published var createIsLoading = false
    
    func getTasks() {
        isLoading = true
        Service.shared.getTasks() { result in
            self.isLoading = false
            switch result {
            case .success(let data):
                self.tasks = data
            case .failure(let error):
                print("Error find tasks: \(error.localizedDescription)")
            }
            
        }
    }
    
    func createTask(task: TaskCreateDTO) {
        createIsLoading = true
        Service.shared.createTask(task: task) { result in
            self.createIsLoading = false
            switch result {
            case .success(let task):
                self.tasks.append(task)
            case .failure(let error):
                print("Error when try create new task: \(error.localizedDescription)")
            }
        }
    }
    
    func editTask(taskId: String, task: TaskCreateDTO) {
        createIsLoading = true
        Service.shared.editTask(taskId: taskId, task: task) { result in
            self.createIsLoading = false
            switch result {
            case .success(let task):
                if let index = self.tasks.firstIndex(where: { $0.id == task.id }) {
                    self.tasks[index].title = task.title
                    self.tasks[index].done = task.done
                }
            case .failure(let error):
                print("Error when try create new task: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteTask(taskId: String) {
        isLoading = true
        Service.shared.deleteTask(taskId: taskId) { result in
            self.isLoading = false
            switch result {
            case .success(let deleted):
                if(deleted){
                    self.tasks.removeAll(where: { $0.id == taskId })
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
