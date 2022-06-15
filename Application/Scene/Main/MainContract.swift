//
//  MainContract.swift
//  Application
//
//  Created by josh.fn7 on 2022/06/15.
//

import Foundation
import RxSwift
import Domain

public enum MainUserAction {
    case add
    case selectItem(TodoItem.ID)
}

public struct MainUIState {
    public let todoItems: [TodoItem]
}

public enum MainRoute {
    case add
    case detail(TodoItem.ID)
}

public protocol MainViewModelProtocol : AnyObject {
    
    /// State stream.
    var state: Observable<MainUIState> { get }
    /// Event stream.
    var route: Observable<MainRoute> { get }
    
    func userAction(_ action: MainUserAction)
    
}

// MARK: Extension

extension MainUserAction : Equatable { }

extension MainUIState : Equatable { }

extension MainRoute : Equatable { }
