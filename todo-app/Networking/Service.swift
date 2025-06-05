//
//  Service.swift
//  todo-app
//
//  Created by Premiersoft on 6/4/25.
//

import Foundation

class Service {
    static let shared = Service()
    private let baseURL = URL(string: "http://172.20.205.254:8000")!
    
    func getTasks(completion: @escaping (Result<[TaskModel], Error>) -> Void) {
        let request = URLRequest(url: baseURL.appending(path: "/tasks"))
        
        URLSession.shared.dataTask(with: request) { data, respnse, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else { return }
            
            do {
                let tasks = try JSONDecoder().decode([TaskModel].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(tasks))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func createTask(task: TaskCreateDTO, completion: @escaping (Result<TaskModel, Error>) -> Void) {
        var request = URLRequest(url: baseURL.appending(path: "/tasks"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(task)
            request.httpBody = jsonData
        } catch {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else { return }
            
            do {
                let createdTask = try JSONDecoder().decode(TaskModel.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(createdTask))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func editTask(taskId: String, task: TaskCreateDTO, completion: @escaping (Result<TaskModel, Error>) -> Void) {
        var request = URLRequest(url: baseURL.appending(path: "/tasks/\(taskId)"))
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(task)
            request.httpBody = jsonData
        } catch {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else { return }
            
            do {
                let createdTask = try JSONDecoder().decode(TaskModel.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(createdTask))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func deleteTask(taskId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        var request = URLRequest(url: baseURL.appending(path: "/tasks/\(taskId)"))
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 204 || httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        completion(.success(true))
                    }
                } else {
                    completion(.failure(NSError(domain: "",
                                                code: httpResponse.statusCode,
                                                userInfo: [NSLocalizedDescriptionKey:"Erro ao deletar: status \(httpResponse.statusCode)"]
                                               ))
                    )
                }
            }
        }.resume()
    }
    
}
