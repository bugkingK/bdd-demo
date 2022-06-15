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
    }
    
    public init(
        todoItemStore: TodoItemStore)
    {
        
    }
    
}

