//
//  ChatViewModel.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 06.05.2024.
//

import Foundation
import FirebaseFirestore

struct FirebaseConstants {
    static let timestamp = "timestamp"
    static let fromId = "fromId"
    static let toId = "toId"
    static let text = "text"
}

class ChatViewModel: ObservableObject {

    @Published var chatText = ""
    @Published var errorMessage = ""
    @Published var count = 0
    @Published var chatMessages = [ChatMessage]()

    @Published var product: Product?
    @Published var productUid: String = ""
    @Published var offerProduct: Product?
    @Published var offerProductUid: String = ""

    @Published var shouldShowCloseProductOptions = false

    var firestoreListener: ListenerRegistration?
    var changeProduct: Product?
    var messageWasSent = false

    let chatUser: User?

    init(chatUser: User?, product: Product? = nil, changeProduct: Product? = nil) {
        self.chatUser = chatUser

        if let setProduct = product {
            self.product = setProduct
            self.productUid = setProduct.productUid
        }
        if let setProduct = changeProduct {
            self.offerProduct = setProduct
            self.offerProductUid = setProduct.productUid
        }
        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchMessages()
        }
    }

    func handleSendMessage() {
        let text = chatText
        print(text)
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid,
              let toId = chatUser?.uid  else {
            return
        }

        let document = FirebaseManager.shared.firestore
            .collection("messages")
            .document(fromId)
            .collection(toId)
            .document()

        var messageData = [
            FirebaseConstants.fromId: fromId,
            FirebaseConstants.toId: toId,
            FirebaseConstants.text: text,
            FirebaseConstants.timestamp: Timestamp(),
            "productUid": productUid,
            "offerProductUid": offerProductUid
        ] as [String : Any]

        document.setData(messageData) { error in
            if let error = error {
                self.errorMessage = "Failed to save message into Firestore: \(error)"
                print("Failed to save message into Firestore: \(error)")
                return
            }

            print("Successfully saved current user message")

            self.chatText = ""
            DispatchQueue.main.async {
                self.count += 1
            }
        }

        let recipientMessageDocument = FirebaseManager.shared.firestore
            .collection("messages")
            .document(toId)
            .collection(fromId)
            .document()

        recipientMessageDocument.setData(messageData) { error in
            if let error = error {
                self.errorMessage = "Failed to save message into Firestore: \(error)"
                print("Failed to save message into Firestore: \(error)")
                return
            }

            DispatchQueue.main.async {
                self.persistRecentMessage(data: messageData)
            }

            print("Successfully saved recipient user message")
        }
    }

    private func persistRecentMessage(data: [String: Any]) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid,
              let toId = self.chatUser?.uid else {
            return
        }

        let document = FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .document(toId)

        document.setData(data) { error in
            if let error = error {
                self.errorMessage = "Failed to save recent message: \(error)"
                print("Failed to save recent message: \(error)")
                return
            }

            print("Successfully saved recent message")
        }

        let recipientRecentMessageDocument = FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(toId)
            .collection("messages")
            .document(uid)

        recipientRecentMessageDocument.setData(data) { error in
            if let error = error {
                self.errorMessage = "Failed to save recent message: \(error)"
                print("Failed to save recent message: \(error)")
                return
            }

            print("Successfully saved recipient recent message")
        }
    }

    private func fetchProduct(productUid: String, offer: Bool) {
        FirebaseManager.shared.fetchProducts(productUids: [productUid]) { products, error in
            if let err = error {
                print("failed to fetch product: \(err)")
                return
            }

            guard let exProducts = products else {
                print("failed to fetch product")
                return
            }

            if exProducts.count > 0 {
                if offer {
                    self.offerProduct = exProducts[0]
                    self.offerProductUid = productUid
                } else {
                    self.product = exProducts[0]
                    self.productUid = productUid
                }
            }
        }
    }

    func closeProduct() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            return
        }

        guard let exProduct = product else {
            return
        }

        let productData = [
            "productUid": exProduct.productUid,
            "userUid": exProduct.userUid,
            "title": exProduct.title,
            "description": exProduct.description,
            "productImageUrls": exProduct.productImageUrls,
            "type": exProduct.category.toString(),
            "subtype": exProduct.category.toStringSubtype(),
            "condition": exProduct.condition.rawValue,
            FirebaseConstants.timestamp: Timestamp(),
            "location": exProduct.location,
            "isClosed": true
        ] as [String : Any]

        FirebaseManager.shared.firestore
            .collection("products")
            .document(productUid)
            .setData(productData) { error in
                if let error {
                    print(error)
                    return
                }
                print("success closeProduct")
            }
        closeOffer()
    }

    func closeOffer() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            return
        }

        guard let exProduct = offerProduct else {
            return
        }

        let productData = [
            "productUid": exProduct.productUid,
            "userUid": exProduct.userUid,
            "title": exProduct.title,
            "description": exProduct.description,
            "productImageUrls": exProduct.productImageUrls,
            "type": exProduct.category.toString(),
            "subtype": exProduct.category.toStringSubtype(),
            "condition": exProduct.condition.rawValue,
            FirebaseConstants.timestamp: Timestamp(),
            "location": exProduct.location,
            "isClosed": true
        ] as [String : Any]

        FirebaseManager.shared.firestore
            .collection("products")
            .document(offerProductUid)
            .setData(productData) { error in
                if let error {
                    print(error)
                    return
                }
                print("success closeOffer")
            }
    }

    private func fetchMessages() {
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = chatUser?.uid else { return }

        firestoreListener?.remove()
        chatMessages.removeAll()

        DispatchQueue.global(qos: .userInitiated).async {
            self.firestoreListener = FirebaseManager.shared.firestore
                .collection("messages")
                .document(fromId)
                .collection(toId)
                .order(by: "timestamp", descending: false)
                .addSnapshotListener { querySnapshot, error in
                    if let error = error {
                        self.errorMessage = "Failed to listen for messages: \(error)"
                        print(error)
                        return
                    }

                    querySnapshot?.documentChanges.forEach({ change in
                        if change.type == .added {
                            let data = change.document.data()
                            self.chatMessages.append(.init(documentId: change.document.documentID, data: data))
                            if let uid = data["productUid"] as? String, !uid.isEmpty {
                                self.fetchProduct(productUid: uid, offer: false)
                            }
                            if let uid = data["offerProductUid"] as? String, !uid.isEmpty {
                                self.fetchProduct(productUid: uid, offer: true)
                            }
                        }
                    })

                    DispatchQueue.main.async {
                        self.count += 1
                    }
                }
        }
    }
}
