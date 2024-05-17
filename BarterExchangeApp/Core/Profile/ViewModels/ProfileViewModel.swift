//
//  ProfileFilterViewModel.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 18.04.2024.
//

import SwiftUI
import FirebaseFirestore

class ProfileViewModel: ObservableObject {
    @Published var selectedFilter: ProfileFilterViewModel = .sells
    @Published var user: User = User(data: [:])
    @Published var products: [Product] = []
    @Published var favorites: [Product] = []
    @Published var closedProducts: [Product] = []

    @Published var shoulShowEditProfile = false

    var didLogOut: () -> ()
    var getFavorites: () -> [Product]

    init(didLogOut: @escaping () -> Void, getFavorites: @escaping () -> [Product]) {
        self.didLogOut = didLogOut
        self.getFavorites = getFavorites

        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchCurrentUser()
        }
    }

    func handleSignOut() {
        try? FirebaseManager.shared.auth.signOut()
        didLogOut()
    }

    func fetchFavorites() {
        favorites = getFavorites()
    }

    func fetchProducts() {
        FirebaseManager.shared.fetchProducts(uid: self.user.uid) { allProducts, error in
            guard let products = allProducts else {
                if let error {
                    print(error)
                }
                return
            }

            self.products = products
            self.objectWillChange.send()
        }
        FirebaseManager.shared.fetchClosedProducts(uid: self.user.uid) { allProducts, error in
            guard let products = allProducts else {
                if let error {
                    print(error)
                }
                return
            }

            self.closedProducts = products
            self.objectWillChange.send()
        }
    }

    func fetchCurrentUser() {

        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            print("Could not find firebase uid")
            return
        }


        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("Failed to fetch current user: \(error)")
                return
            }

            guard let data = snapshot?.data() else {
                print("No data found")
                return

            }
            self.user = User(data: data)
            self.fetchProducts()
        }
    }
}

enum ProfileFilterViewModel: Int, CaseIterable {
    case sells
    case wants
    case concluded

    var title: String {
        switch self {
        case .sells:
            "Объявления"
        case .wants:
            "Избранное"
        case .concluded:
            "Завершенные"
        }
    }
}
