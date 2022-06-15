//
//  StubTodoItemStore.swift
//  Todo
//
//  Created by josh.fn7 on 2022/06/15.
//

import Foundation
import RxSwift
import Domain
import Application
import Common

final class StubTodoItemStore : TodoItemStore {
    
    var itemsSubject = BehaviorSubject<[TodoItem]>(value: [])
    var items: Observable<[TodoItem]> { itemsSubject }
    
    func addItem(_ item: TodoItem) -> Single<String> {
        let newItemList = variable(try! itemsSubject.value()) {
            $0.append(.with(id: "\($0.count + 1)", item: item))
        }
        itemsSubject.onNext(newItemList)
        
        return .just(newItemList.last!.id)
    }
    
    func removeItem(id: String) -> Single<TodoItem> {
        do {
            var item: TodoItem?
            let newItemList = try variable(try! itemsSubject.value()) {
                if let index = $0.firstIndex(where: { $0.id == id }) {
                    item = $0[index]
                    $0.remove(at: index)
                } else {
                    throw GeneralError.illegalArgument
                }
            }
            
            itemsSubject.onNext(newItemList)
            
            return .just(item!)
        } catch {
            return .error(error)
        }
    }
    
    func updateItem(_ item: TodoItem) -> Single<Void> {
        do {
            let newItemList = try variable(try! itemsSubject.value()) { itemList in
                guard let index = itemList.firstIndex(where: { $0.id == item.id })
                else { throw GeneralError.illegalArgument }
                
                itemList[index] = TodoItem(
                    id: itemList[index].id,
                    title: item.title,
                    detail: item.detail,
                    createdAt: itemList[index].createdAt,
                    tags: item.tags,
                    completedAt: item.completedAt)
            }
            
            itemsSubject.onNext(newItemList)
            
            return .just(())
        } catch {
            return .error(error)
        }
    }
    
}

private extension TodoItem {
    
    static func with(id: String, item: TodoItem) -> TodoItem {
        TodoItem(id: id, title: item.title, detail: item.detail, createdAt: item.createdAt, tags: item.tags, completedAt: item.completedAt)
    }
    
}
