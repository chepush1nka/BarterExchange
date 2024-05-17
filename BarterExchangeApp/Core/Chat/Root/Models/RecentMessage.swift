//
//  RecentMessage.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 07.05.2024.
//

import FirebaseFirestore

class RecentMessage: Identifiable {
    var id: String {
        documentId
    }

    let documentId: String
    let fromId, toId: String
    var sender: User?
    var text: String
    let timestamp: Timestamp

    init(documentId: String, text: String, fromId: String, toId: String, sender: User?, timestamp: Timestamp) {
        self.documentId = documentId
        self.text = text
        self.fromId = fromId
        self.toId = toId
        self.sender = sender
        self.timestamp = timestamp
    }

    init(documentId: String, data: [String: Any], completion: @escaping (RecentMessage) -> Void) {
        self.documentId = documentId
        self.text = data["text"] as? String ?? ""
        self.fromId = data["fromId"] as? String ?? ""
        self.toId = data["toId"] as? String ?? ""
        self.timestamp = data["timestamp"] as? Timestamp ?? Timestamp()
        if data["timestamp"] as? Timestamp == nil {
            print("fsbfbsfsb")
        }
        self.sender = nil

        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            completion(self)
            return
        }

        let senderId = uid == fromId ? toId : fromId

        DispatchQueue.global(qos: .userInitiated).async {
            FirebaseManager.shared.firestore
                .collection("users")
                .document(senderId)
                .getDocument { snapshot, error in
                if let error = error {
                    print("Failed to fetch sender user:", error)
                    completion(self)
                    return
                }

                guard let data = snapshot?.data() else {
                    print("No data found")
                    completion(self)
                    return
                }

                self.sender = User(data: data)
                completion(self)
            }
        }
    }
}

