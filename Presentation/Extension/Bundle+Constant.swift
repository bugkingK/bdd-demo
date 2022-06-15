//
//  Bundle+Constant.swift
//  Presentation
//
//  Created by josh.fn7 on 2022/06/15.
//

import Foundation

extension Bundle {
    private class _Context { }
    
    static let current = Bundle(for: _Context.self)
}
