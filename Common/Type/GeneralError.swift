//
//  GeneralError.swift
//  Common
//
//  Created by josh.fn7 on 2022/06/15.
//

import Foundation

public enum GeneralError : Error {
    case illegalArgument
    case invalidState
    case cause(Error)
    case unknown(String?)
}
