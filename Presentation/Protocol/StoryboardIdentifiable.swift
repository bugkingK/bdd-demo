//
//  StoryboardIdentifiable.swift
//  Presentation
//
//  Created by josh.fn7 on 2022/06/15.
//

import Foundation

protocol StoryboardIdentifiable : AnyObject {
    static var storyboardID: String { get }
}

extension StoryboardIdentifiable {
    static var storyboardID: String { "\(Self.self)" }
}
