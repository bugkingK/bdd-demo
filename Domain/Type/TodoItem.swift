//
//  TodoItem.swift
//  Domain
//
//  Created by josh.fn7 on 2022/06/14.
//

import Foundation

public struct TodoItem : Identifiable {
    public let id: String
    public var title: String
    public var detail: String?
    public let createdAt: Date
    public var tags: [String]
    public var completedAt: Date?

    public init(id: String = "", title: String, detail: String? = nil, createdAt: Date, tags: [String], completedAt: Date? = nil) {
        self.id = id
        self.title = title
        self.detail = detail
        self.createdAt = createdAt
        self.tags = tags
        self.completedAt = completedAt
    }
}

extension TodoItem : Equatable { }
