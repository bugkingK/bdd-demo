//
//  Observable+Extension.swift
//  Common
//
//  Created by josh.fn7 on 2022/06/15.
//

import Foundation
import RxSwift

public extension Observable {
    
    var lastValue: Element? {
        var value: Element?
        subscribe(onNext: { value = $0 }).dispose()
        return value
    }
    
}
