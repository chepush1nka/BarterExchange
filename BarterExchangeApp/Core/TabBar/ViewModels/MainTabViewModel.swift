//
//  MainTabViewModel.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 10.05.2024.
//

import SwiftUI
import FirebaseFirestore

class MainTabViewModel: ObservableObject {
    @Published var favorites: [Product] = []

    var firestoreListener: ListenerRegistration?

    init() {
        DispatchQueue.global(qos: .background).async {
            self.fetchFavorites()
        }
    }

    

    func fetchFavorites() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            print("Could not find firebase uid")
            return
        }
        
        firestoreListener?.remove()

        firestoreListener = FirebaseManager.shared.firestore
            .collection("users")
            .document(uid)
            .collection("favorites")
            .addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    return
                }

                guard let snapshot = snapshot else {
                    print("Snapshot is nil")
                    return
                }

                var favoritesUid: [String] = []

                for document in snapshot.documents {
                    let data = document.data()
                    guard
                        let productUid = data["productUid"] as? String,
                        let userUid = data["userUid"] as? String
                    else {
                        continue
                    }

                    favoritesUid.append(productUid)
                }

                FirebaseManager.shared.fetchProducts(productUids: favoritesUid) { allProducts, error in
                    guard let products = allProducts else {
                        if let error = error {
                            print(error)
                        }
                        return
                    }
                    self.favorites = products
                    self.objectWillChange.send()
                }
            }
    }
}

