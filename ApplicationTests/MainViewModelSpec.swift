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
        
        describe("action ADD") {
            beforeEach {
                sut.userAction(.add)
            }
            
            it("route ADD") {
                expect(routeObserver.events).to(haveCount(1))
                expect(routeObserver.events.last?.value.element).to(equal(.add))
            }
        }
        
        describe("action SELECT_ITEM") {
            it("BOTTOM") {
                expect(sut.userAction(.selectItem(UUID().uuidString))).to(throwAssertion())
            }
        }
        
        describe("TodoItemStore items 갱신") {
            var todoItems: [TodoItem]!
            
            beforeEach {
                todoItems = (1 ... 10).map { .random(id: "\($0)") }
                todoItemStore.itemsSubject.onNext(todoItems)
                scheduler.advanceTo(2)
            }
            
            it("state 갱신") {
                let expected = MainUIState(mode: .browse, todoItems: todoItems, selectedItemIDs: nil)
                expect(stateObserver.events).to(haveCount(2))
                expect(stateObserver.events.last?.value.element).to(equal(expected))
            }
            
            context("action TOGGLE_MODE") {
                beforeEach {
                    sut.userAction(.toggleMode)
                }
                
                it("state mode EDIT") {
                    expect(stateObserver.events).to(haveCount(3))
                    expect(stateObserver.events.last?.value.element?.mode).to(equal(.edit))
                }
                
                context("action TOGGLE_MODE") {
                    beforeEach {
                        sut.userAction(.toggleMode)
                    }
                    
                    it("state mode BROWSE") {
                        expect(stateObserver.events).to(haveCount(4))
                        expect(stateObserver.events.last?.value.element?.mode).to(equal(.browse))
                    }
                }
                
                context("action DELETE_ITEMS") {
                    it("BOTTOM") {
                        expect(sut.userAction(.deleteItems)).to(throwAssertion())
                    }
                }
                
                context("action SELECT_ITEM") {
                    var selectedItems: [TodoItem]!
                    
                    beforeEach {
                        selectedItems = Array(todoItems.shuffled()[0...1])
                        selectedItems.forEach {
                            sut.userAction(.selectItem($0.id))
                        }
                    }
                    
                    it("route 반응 없음") {
                        expect(routeObserver.events).to(beEmpty())
                    }
                    
                    it("state selectedItemIDs 갱신") {
                        let selectedIDs = selectedItems.map(\.id)
                        expect(stateObserver.events).to(haveCount(5))
                        expect(stateObserver.events.dropLast().last?.value.element?.selectedItemIDs).to(equal(Array(selectedIDs.dropLast())))
                        expect(stateObserver.events.last?.value.element?.selectedItemIDs).to(equal(selectedIDs))
                    }
                    
                    context("action DELETE_ITEMS") {
                        beforeEach {
                            sut.userAction(.deleteItems)
                        }
                        
                        // 실제로 삭제되는지는 TodoItemStore 의 구현에 대한 테스트이기 때문에 할 필요가 없음.
                        // 삭제된 것이 반영되는지는 TodoItemStore 구현체에서 테스트 해야 함.
                        // TodoItemStore.item 의 변경 사항에 대한 반영은 "TodoItemStore items 갱신"에서 테스트 중.
                        it("TodoItemStore removeItem") {
                            expect(todoItemStore.removeItemArgs).to(haveCount(2))
                            expect(Set(todoItemStore.removeItemArgs)).to(equal(Set(selectedItems.map(\.id))))
                        }
                    }
                }
            }
            
            context("action SELECT_ITEM") {
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
