//
//  TodoItemStore.swift
//  Application
//
//  Created by josh.fn7 on 2022/06/15.
//

import Foundation
import Domain
import RxSwift

public protocol TodoItemStore : AnyObject {
    
    /// - Returns: State stream.
    var items: Observable<[TodoItem]> { get }
    
    /// - Note: `item.id`는 무시되고, store 내부에서 유효한 `id`가 배정됨.
    /// - Postcondition: `items`에 `id`가 배정된 상태의 `item`이 추가됨.
    /// - Returns:추가된 `item.id`.
    @discardableResult
    func addItem(_ item: TodoItem) -> Single<String>
    
    /// - Throws: `GeneralError.illegalArgument` 존재하지 않는 `id`.
    /// - Postcondition: `items`에서 리턴되는 `TodoItem`이 제거됨.
    @discardableResult
    func removeItem(id: String) -> Single<TodoItem>
    
    /// - Throws: `GeneralError.illegalArgument` 존재하지 않는 `id`
    /// - Postcondition: `items`에 변화 반영.
    @discardableResult
    func updateItem(_ item: TodoItem) -> Single<Void>
    
}
