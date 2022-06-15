//
//  MockTodoItemStore.swift
//  ApplicationTests
//
//  Created by josh.fn7 on 2022/06/15.
//

import Foundation
import Domain
import RxSwift
import Application

class MockTodoItemStore : TodoItemStore {
    
    let itemsSubject = BehaviorSubject<[TodoItem]>(value: [])
    var items: Observable<[TodoItem]> { itemsSubject }
    
    var addItemArgs: [TodoItem] = []
    var addItemCont: ((SingleEvent<String>) -> Void)!
    func addItem(_ item: TodoItem) -> Single<String> {
        addItemArgs.append(item)
        return .create {
            self.addItemCont = $0
            return Disposables.create()
        }
    }
    
    var removeItemArgs: [String] = []
    var removeItemCont: ((SingleEvent<TodoItem>) -> Void)!
    func removeItem(id: String) -> Single<TodoItem> {
        removeItemArgs.append(id)
        return .create {
            self.removeItemCont = $0
            return Disposables.create()
        }
    }
    
    var updateItemArgs: [TodoItem] = []
    var updateItemCont: ((SingleEvent<Void>) -> Void)!
    func updateItem(_ item: TodoItem) -> Single<Void> {
        updateItemArgs.append(item)
        return .create {
            self.updateItemCont = $0
            return Disposables.create()
        }
    }
    
}
