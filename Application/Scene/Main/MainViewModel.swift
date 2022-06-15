//
//  MainViewModel.swift
//  Application
//
//  Created by josh.fn7 on 2022/06/15.
//

import Foundation
import RxSwift
import Domain

public class MainViewModel : MainViewModelProtocol {
    
    private let _state = BehaviorSubject<MainUIState>(value: .empty)
    public var state: Observable<MainUIState> { _state.distinctUntilChanged() }
    
    private let _route = PublishSubject<MainRoute>()
    public var route: Observable<MainRoute> { _route }
    
    public func userAction(_ action: MainUserAction) {
        switch action {
        case .add:
            _route.onNext(.add)
        case .selectItem(let itemID):
            assert(try! _state.value().todoItems.contains(where: { $0.id == itemID }))
            _route.onNext(.detail(itemID))
        }
    }
    
    private let scheduler: SchedulerType
    private let scope = DisposeBag()
    
    private let todoItemStore: TodoItemStore
    
    private func observeTodoItems() {
        todoItemStore.items
            .withUnretained(self)
            .observe(on: scheduler)
            .subscribe(onNext: { vm, items in
                vm._state.onNext(.init(todoItems: items))
            })
            .disposed(by: scope)
    }
    
    public init(
        scheduler: SchedulerType,
        todoItemStore: TodoItemStore)
    {
        self.scheduler = scheduler
        self.todoItemStore = todoItemStore
        
        observeTodoItems()
    }
    
}

