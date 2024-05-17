//
//  RootChatViewModel.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 01.05.2024.
//

import SwiftUI
import FirebaseFirestore

class RootChatViewModel: ObservableObject {
    @Published var errorMessage = ""
    @Published var chatUser: User?
    @Published var recentMessages: [RecentMessage] = []
    @Published var isChatViewPresented = false
    @Published var searchText = ""

    var firestoreListener: ListenerRegistration?

    var filteredMessages: [RecentMessage] {
        guard !searchText.isEmpty else {
            return recentMessages
        }
        return recentMessages.filter { $0.sender?.name.localizedStandardContains(searchText) == true }
    }

    init() {
        fetchCurrentUser()
        fetchRecentMessages()
    }

    func fetchRecentMessages() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return
        }

        firestoreListener?.remove()

        DispatchQueue.global(qos: .background).async {
            self.firestoreListener = FirebaseManager.shared.firestore
                .collection("recent_messages")
                .document(uid)
                .collection("messages")
                .order(by: "timestamp")
                .addSnapshotListener { querySnapshot, error in
                    if let error = error {
                        self.errorMessage = "Failed to listen for recent messages: \(error)"
                        print("Failed to listen for recent messages: \(error)")
                        return
                    }

                    querySnapshot?.documentChanges.forEach({ change in
                        let docId = change.document.documentID

                        if let index = self.recentMessages.firstIndex(where: { rm in
                            return rm.documentId == docId
                        }) {
                            self.recentMessages.remove(at: index)
                        }

                        RecentMessage(documentId: docId, data: change.document.data()) { recentMessage in
                            self.recentMessages.append(recentMessage)
                            self.recentMessages = self.recentMessages.sorted {$0.timestamp.dateValue() > $1.timestamp.dateValue()}
                        }
                    })
                }
        }
    }

    private func fetchCurrentUser() {

        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return
        }


        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user:", error)
                return
            }

            guard let data = snapshot?.data() else {
                self.errorMessage = "No data found"
                return

            }
            self.chatUser = User(data: data)
        }
    }
}
