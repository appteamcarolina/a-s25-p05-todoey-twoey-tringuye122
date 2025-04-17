//
//  Todo.swift
//  Todoey
//
//  Created by Tri Nguyen on 4/17/25.
//

import Foundation

struct NewTodo: Codable {
    let title: String
}

struct Todo: Identifiable, Codable {
    let id: UUID
    let title: String
    var isCompleted: Bool
}
