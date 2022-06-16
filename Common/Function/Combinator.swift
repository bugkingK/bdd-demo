//
//  Combinator.swift
//  Common
//
//  Created by josh.fn7 on 2022/06/15.
//

import Foundation

public func id<T>(_ value: T) -> T { value }

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

public func flatten<A, B, C>(_ tuple: (A, B), _ c: C) -> (A, B, C) { (tuple.0, tuple.1, c) }

public func flatten<A, B, C>(_ a: A, _ tuple: (B, C)) -> (A, B, C) { (a, tuple.0, tuple.1) }

public func flatten<A, B, C, D>(_ tuple: (A, B, C), _ d: D) -> (A, B, C, D) { (tuple.0, tuple.1, tuple.2, d) }

public func flatten<A, B, C, D>(_ a: A, _ tuple: (B, C, D)) -> (A, B, C, D) { (a, tuple.0, tuple.1, tuple.2) }

