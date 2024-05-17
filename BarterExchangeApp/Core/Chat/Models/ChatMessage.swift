//
//  ChatMessage.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 13.05.2024.
//

struct ChatMessage: Identifiable {
    var id: String { documentId }

    let documentId: String
    let fromId, toId, text, type: String
    let productUid: String?

    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.fromId = data[FirebaseConstants.fromId] as? String ?? ""
        self.toId = data[FirebaseConstants.toId] as? String ?? ""
        self.text = data[FirebaseConstants.text] as? String ?? ""
        self.type = data["type"] as? String ?? "message"
        self.productUid = data["offerProductUid"] as? String
    }
}
