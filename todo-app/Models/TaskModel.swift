//
//  Task.swift
//  todo-app
//
//  Created by Premiersoft on 6/4/25.
//

import Foundation

struct TaskModel: Identifiable, Codable {
    let id: String?
    var title: String
    var done: Bool
}

struct TaskCreateDTO: Codable {
    var title: String
    var done: Bool
}
