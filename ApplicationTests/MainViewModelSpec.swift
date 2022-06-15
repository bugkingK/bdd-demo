//
//  MainViewModelSpec.swift
//  ApplicationTests
//
//  Created by josh.fn7 on 2022/06/15.
//

import Foundation
import Quick
import Nimble
import Application
import RxSwift
import RxTest

class MainViewModelSpec : QuickSpec {
    
    override func spec() {
        var scheduler: TestScheduler!
        var scope: DisposeBag!
        
        var sut: MainViewModel!
        
        var stateObserver: TestableObserver<MainUIState>!
        var routeObserver: TestableObserver<MainRoute>!
        
        beforeEach {
            scheduler = .init(initialClock: 0)
            scope = .init()
            
            sut = .init()
            
            stateObserver = scheduler.createObserver(MainUIState.self)
            sut.state.subscribe(stateObserver).disposed(by: scope)
            
            routeObserver = scheduler.createObserver(MainRoute.self)
            sut.route.subscribe(routeObserver).disposed(by: scope)
        }
        
        it("초기 샅애") {
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
    }
    
}
