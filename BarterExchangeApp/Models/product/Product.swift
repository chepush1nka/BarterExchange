//
//  Product.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 31.01.2024.
//

import Foundation
import FirebaseFirestore
import SwiftUI
import UniformTypeIdentifiers

struct Product: Hashable, Codable, Transferable {

    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .developerTask)
    }

    let productUid: String
    let userUid: String
    let title: String
    let description: String
    let productImageUrls: [String]
    let condition: Condition
    let category: Category
    let timestamp: Timestamp
    let location: String
    let isClosed: Bool

    init(
        productUid: String,
        userUid: String,
        title: String,
        description: String,
        productImageUrls: [String],
        type: String,
        subtype: String,
        condition: String,
        timestamp: Timestamp,
        location: String,
        isClosed: Bool
    ) {
        self.productUid = productUid
        self.userUid = userUid
        self.title = title
        self.description = description
        self.productImageUrls = productImageUrls
        self.condition = Condition.mapToCondition(from: condition)
        self.category = Category.mapToCategory(from: type, with: subtype)
        self.timestamp = timestamp
        self.location = location
        self.isClosed = isClosed
    }

    init(data: [String: Any]) {
        self.productUid = data["productUid"] as? String ?? ""
        self.userUid = data["userUid"] as? String ?? ""
        self.title = data["title"] as? String ?? ""
        self.description = data["description"] as? String ?? ""
        self.productImageUrls = data["productImageUrls"] as? [String] ?? [""]
        self.condition = Condition.mapToCondition(from: data["condition"] as? String ?? "")
        self.category = Category.mapToCategory(from: data["type"] as? String ?? "", with: data["subtype"] as? String ?? "")
        self.timestamp = data["timestamp"] as? Timestamp ?? Timestamp()
        self.location = data["location"] as? String ?? ""
        self.isClosed = data["isClosed"] as? Bool ?? false
    }
}

extension UTType {
    static let developerTask = UTType(exportedAs: "pvvyaltsev.BarterExchangeApp.developerTask")
}
