//
//  ToDoListService.swift
//  Todoey
//
//  Created by Tri Nguyen on 4/17/25.
//

import Foundation

enum TodoListService {
    static let decoder = JSONDecoder()
    static let encoder = JSONEncoder()
    
    static let baseUrl = "https://learning.ryderklein.com/todos"
    
    static func getTodos() async throws -> [Todo] {
        // TODO: Implement
        let components = URLComponents(string: baseUrl)
        
        guard let url = components?.url else {
            fatalError("invalid URL")
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let todos = try decoder.decode([Todo].self, from: data)
        
        return todos
    }
    
    static func create(newTodo: NewTodo) async throws -> Todo {
        // TODO: Implement
        let components = URLComponents(string: baseUrl)
        
        guard let url = components?.url else {
            fatalError("invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try encoder.encode(newTodo)
        request.httpBody = jsonData
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let todo = try decoder.decode(Todo.self, from: data)
        return todo
    }
    
    static func delete(todo: Todo) async throws {
        // TODO: Implement
        let components = URLComponents(string: "\(baseUrl)/\(todo.id)")
        
        guard let url = components?.url else {
            fatalError("invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        _ = try await URLSession.shared.data(for: request)
    }
    
    static func updateCompletion(for todo: Todo, isCompleted: Bool) async throws {
        var components = URLComponents(string: "\(baseUrl)/\(todo.id)/updateCompleted")
        components?.queryItems = [
            URLQueryItem(name: "isCompleted", value: "\(isCompleted)")
        ]
        
        guard let url = components?.url else {
            fatalError("invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        
        _ = try await URLSession.shared.data(for: request)
    }
}
