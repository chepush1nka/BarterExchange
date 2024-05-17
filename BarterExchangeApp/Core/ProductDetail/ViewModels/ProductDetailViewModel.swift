//
//  ProductDetailViewModel.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 09.05.2024.
//

import SwiftUI
import PhotosUI
import FirebaseFirestore

class ProductDetailViewModel: ObservableObject {
    @Published var product: Product
    @Published var seller: User = User(data: [:])
    @Published var isOwnerLooking = false
    @Published var isFavorite: Bool {
        didSet {
            if isFavorite == false {
                removeFromFavorites()
            } else {
                saveToFavorites()
            }
        }
    }

    @Published var showProfile = false
    @Published var showSelectProduct = false
    @Published var showEditProduct = false

    @Published var showChatWithProduct = false
    @Published var productToOffer: Product? = nil

    var getFavorites: () -> [Product]

    init(product: Product, getFavorites: @escaping () -> [Product]) {
        self.getFavorites = getFavorites
        self.product = product
        self.isFavorite = getFavorites().contains(product)

        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchUser()
        }
    }

    func fetchUser() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            print("Could not find firebase uid")
            return
        }

        FirebaseManager.shared.firestore
            .collection("users")
            .document(product.userUid)
            .getDocument { snapshot, error in
            if let error = error {
                print("Failed to fetch current user:", error)
                return
            }

            guard let data = snapshot?.data() else {
                print("No data found")
                return
            }

            self.seller = User(data: data)
            if self.seller.uid == uid {
                self.isOwnerLooking = true
            }
        }
    }

    func removeFromFavorites() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            return
        }

        FirebaseManager.shared.firestore
            .collection("users")
            .document(uid)
            .collection("favorites")
            .document(product.productUid)
            .delete() { error in
                if let error = error {
                    print("Error removing favorite: \(error)")
                } else {
                    print("Favorite successfully removed!")
                }
            }
    }

    func saveToFavorites() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            return
        }

        let data = [
            "productUid": product.productUid,
            "userUid": uid,
        ] as [String : Any]

        FirebaseManager.shared.firestore
            .collection("users")
            .document(uid)
            .collection("favorites")
            .document(product.productUid)
            .setData(data) { error in
                if let error {
                    print(error)
                    return
                }
                print("success saveToFavorites")
            }
    }
}
