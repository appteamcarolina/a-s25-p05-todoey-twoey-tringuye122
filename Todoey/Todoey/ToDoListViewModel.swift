//
//  ToDoListViewModel.swift
//  Todoey
//
//  Created by Tri Nguyen on 4/17/25.
//

import Foundation

enum TodoListLoadingState {
    // TODO: Implement TodoListLoadingState
    // with success, error, loading, and idle states
    case idle
    case loading
    case success(todos: [Todo])
    case error(message: String)
}

@MainActor
class TodoListViewModel: ObservableObject {
    @Published var state: TodoListLoadingState = .idle
    @Published var todos: [Todo] = []
    
    func fetchTodos() async {
        do {
            self.state = .loading
            
            self.todos = try await TodoListService.getTodos()
            
            // TODO: Set state to success
            self.state = .success(todos: self.todos)
            
        } catch {
            // TODO: Set state to error
            self.state = .error(message: error.localizedDescription)
        }
    }

    func createTodo(title: String) async {
        // TODO: Implement createTodo using TodoListService.create() (see fetchTodos)
        do {
            self.state = .loading

            let newTodo = NewTodo(title: title)
            let todo = try await TodoListService.create(newTodo: newTodo)
            
            self.todos.append(todo)
            
            self.state = .success(todos: self.todos)
            
        } catch {
            self.state = .error(message: error.localizedDescription)
        }
    }

    func delete(todo: Todo) async {
        // TODO: Implement delete
        do {
            self.state = .loading

            try await TodoListService.delete(todo: todo)
            
            self.todos.removeAll { $0.id == todo.id }
            
            self.state = .success(todos: self.todos)
            
        } catch {
            self.state = .error(message: error.localizedDescription)
        }
    }

    func toggleCompletion(for todo: Todo) async {
        // TODO: Implement toggleCompletion
        do {
            self.state = .loading

            try await TodoListService.updateCompletion(for: todo, isCompleted: !todo.isCompleted)
            
            if let index = self.todos.firstIndex(where: { $0.id == todo.id }) {
                self.todos[index].isCompleted = !todo.isCompleted
            }
            
            self.state = .success(todos: self.todos)
            
        } catch {
            self.state = .error(message: error.localizedDescription)
        }
    }
}
