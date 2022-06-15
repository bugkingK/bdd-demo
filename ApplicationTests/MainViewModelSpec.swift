//
//  MainViewModelSpec.swift
//  ApplicationTests
//
//  Created by josh.fn7 on 2022/06/15.
//

import Foundation
import Quick
import Nimble
import Domain
@testable import Application
import RxSwift
import RxTest

class MainViewModelSpec : QuickSpec {
    
    override func spec() {
        var scheduler: TestScheduler!
        var scope: DisposeBag!
        
        var todoItemStore: MockTodoItemStore!
        
        var sut: MainViewModel!
        
        var stateObserver: TestableObserver<MainUIState>!
        var routeObserver: TestableObserver<MainRoute>!
        
        beforeEach {
            scheduler = .init(initialClock: 0)
            scope = .init()
            
            todoItemStore = .init()
            
            sut = .init(
                scheduler: scheduler,
                todoItemStore: todoItemStore)
            
            stateObserver = scheduler.createObserver(MainUIState.self)
            sut.state.subscribe(stateObserver).disposed(by: scope)
            
            routeObserver = scheduler.createObserver(MainRoute.self)
            sut.route.subscribe(routeObserver).disposed(by: scope)
        }
        
        it("초기 상태") {
            expect(stateObserver.events).to(haveCount(1))
            expect(stateObserver.events.last?.value.element).to(equal(.empty))
            
            expect(routeObserver.events).to(beEmpty())
        }
        
        describe("UserAction ADD") {
            beforeEach {
                sut.userAction(.add)
            }
            
            it("route ADD") {
                expect(routeObserver.events).to(haveCount(1))
                expect(routeObserver.events.last?.value.element).to(equal(.add))
            }
        }
        
        describe("UserAction SELECT_ITEM") {
            it("BOTTOM") {
                expect(sut.userAction(.selectItem(UUID().uuidString))).to(throwAssertion())
            }
        }
        
        describe("TodoItem 존재") {
            var todoItems: [TodoItem]!
            
            beforeEach {
                todoItems = (1 ... 10).map { .random(id: "\($0)") }
                todoItemStore.itemsSubject.onNext(todoItems)
                scheduler.advanceTo(2)
            }
            
            it("state 갱신") {
                let expected = MainUIState(todoItems: todoItems)
                expect(stateObserver.events).to(haveCount(2))
                expect(stateObserver.events.last?.value.element).to(equal(expected))
            }
            
            context("UserAction SELECT_ITEM") {
                var selectedItem: TodoItem!
                
                beforeEach {
                    selectedItem = todoItems.randomElement()!
                    sut.userAction(.selectItem(selectedItem.id))
                }
                
                it("route DETAIL") {
                    expect(routeObserver.events).to(haveCount(1))
                    expect(routeObserver.events.last?.value.element).to(equal(.detail(selectedItem.id)))
                }
            }
        }
    }
    
}

extension TodoItem {
    
    static func random(id: String, completedAt: Date? = nil) -> TodoItem {
        TodoItem(id: id, title: UUID().uuidString, detail: UUID().uuidString, createdAt: Date(), tags: [], completedAt: completedAt)
    }
    
}
