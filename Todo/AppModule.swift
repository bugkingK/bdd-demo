//
//  AppModule.swift
//  Todo
//
//  Created by josh.fn7 on 2022/06/15.
//

import UIKit
import RxSwift
import Domain
import Application
import Presentation
import DataAccess

final class AppModule {
    
    static let shared = AppModule()
    
    let window = UIWindow(frame: UIScreen.main.bounds)
    
    private let uiScheduler = MainScheduler.instance
    private let ioScheduler = SerialDispatchQueueScheduler(qos: .userInitiated)
    
    private let todoItemStore: TodoItemStore
    
    private let scope = DisposeBag()
    
    func loadInitial() {
        let vm = MainViewModel(
            scheduler: uiScheduler,
            todoItemStore: todoItemStore)
        observeMainRoute(vm.route)
        
        let vc = MainViewController.createInstance()
        vc.setViewModel(vm)
        
        window.rootViewController = UINavigationController(rootViewController: vc)
    }
    
    private init() {
        todoItemStore = StubTodoItemStore()
    }
    
}

private extension AppModule {
    
    func observeMainRoute(_ mainRoutes: Observable<MainRoute>) {
        mainRoutes
            .withUnretained(self)
            .subscribe(onNext: { module, route in
                switch route {
                case .add:
                    print("추가화면 생략")
                    module.todoItemStore.addNewItem()
                    
                case .detail(let itemID):
                    print(#function, "itemID: \(itemID)")
                }
            })
            .disposed(by: scope)
    }
    
}
