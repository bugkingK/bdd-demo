//
//  Combinator.swift
//  Common
//
//  Created by josh.fn7 on 2022/06/15.
//

import Foundation

public func assign<T>(_ factory: () throws -> T) throws -> T { try factory() }

public func assign<T>(_ factory: () -> T) -> T { factory() }

/**
 - Returns: `object`가 `class` 타입일 경우 동일한 오브젝트. `struct`일 경우 새로운 오브젝트가 생성됨.
 */
public func variable<T>(_ object: T, _ block: (inout T) throws -> Void) throws -> T {
    var copy = object
    try block(&copy)
    return copy
}

/**
 - Returns: `object`가 `class` 타입일 경우 동일한 오브젝트. `struct`일 경우 새로운 오브젝트가 생성됨.
 */
public func variable<T>(_ object: T, _ block: (inout T) -> Void) -> T {
    var copy = object
    block(&copy)
    return copy
}
