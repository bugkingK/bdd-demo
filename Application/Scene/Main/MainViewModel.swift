//
//  MainViewModel.swift
//  Application
//
//  Created by josh.fn7 on 2022/06/15.
//

import Foundation
import RxSwift
import Domain
import Common

public class MainViewModel : MainViewModelProtocol {
    
    private let _state = BehaviorSubject<MainUIState>(value: .empty)
    public var state: Observable<MainUIState> { _state.distinctUntilChanged() }
    
    private let _route = PublishSubject<MainRoute>()
    public var route: Observable<MainRoute> { _route }
    
    public func userAction(_ action: MainUserAction) {
        switch action {
        case .toggleMode:
            _state.onNext(variable(try! _state.value()) {
                $0.mode.toggle()
                $0.selectedItemIDs = $0.mode == .edit ? [] : nil
            })
            
        case .add:
            _route.onNext(.add)
            
        case .selectItem(let itemID):
            assert(try! _state.value().todoItems.contains(where: { $0.id == itemID }))
            switch try! _state.value().mode {
            case .browse:
                _route.onNext(.detail(itemID))
            case .edit:
                _state.onNext(variable(try! _state.value()) {
                    $0.selectedItemIDs!.formSymmetricDifference([itemID])
                })
            }
            
        case .deleteItems:
            assert(try! _state.value().selectedItemIDs?.isEmpty == false)
            
            let removeItemJobs = try! _state.value().selectedItemIDs!.map {
                todoItemStore
                    .removeItem(id: $0)
                    .map(Result<TodoItem, Error>.success)
                    .catch { .just(Result<TodoItem, Error>.failure($0)) }
                    .asObservable()
            }
            
            Observable.zip(removeItemJobs)
                .withUnretained(self)
                .subscribe(onNext: { vm, results in
                    let deletedItemIDs = results.compactMap { try? $0.get().id }
                    vm._state.onNext(variable(try! vm._state.value()) {
                        $0.selectedItemIDs!.subtract(deletedItemIDs)
                    })
                })
                .disposed(by: scope)
        }
    }
    
    private let scheduler: SchedulerType
    private let scope = DisposeBag()
    
    private let todoItemStore: TodoItemStore
    
    private func observeTodoItems() {
        todoItemStore.items
            .withUnretained(self)
            .withLatestFrom(_state, resultSelector: flatten)
            .observe(on: scheduler)
            .subscribe(onNext: { vm, items, state in
                vm._state.onNext(MainUIState(mode: state.mode, todoItems: items, selectedItemIDs: state.selectedItemIDs))
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
