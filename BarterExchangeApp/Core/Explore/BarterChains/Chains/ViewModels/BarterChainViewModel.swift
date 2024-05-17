//
//  BarterChainViewModel.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 12.05.2024.
//

import SwiftUI

class BarterChainsViewModel: ObservableObject {
    var getFavorites: () -> [Product]

    @Published var products: [Product] = []
    @Published var favorites: [Product] = []
    @Published var selectedProduct: Product
    @Published var shoudOpenChains = false

    init(product: Product, getFavorites: @escaping () -> [Product]) {
        self.getFavorites = getFavorites
        self.selectedProduct = product
        products.insert(product, at: 0)
        self.favorites = getFavorites()
        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchBarterChain()
        }
    }

    func saveBarterChain() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            return
        }

        var uids: [String] = []

        for product in products {
            uids.append(product.productUid)
        }

        let chainData = [
            "productUid": selectedProduct.productUid,
            "userUid": uid,
            "stepsUids": uids
        ] as [String : Any]

        FirebaseManager.shared.firestore
            .collection("users")
            .document(uid)
            .collection("chains")
            .document(selectedProduct.productUid)
            .setData(chainData) { error in
                if let error {
                    print(error)
                    return
                }
                print("success saveBarterChain")
            }
    }
    
    private func fetchBarterChain() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            return
        }

        FirebaseManager.shared.firestore
            .collection("users")
            .document(uid)
            .collection("chains")
            .whereField("productUid", isEqualTo: selectedProduct.productUid)
            .getDocuments() { snapshot, error in
                if let error {
                    print(error)
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No barter chains found")
                    return
                }

                for document in documents {
                    let data = document.data()

                    guard let productUid = data["productUid"] as? String,
                          let userUid = data["userUid"] as? String,
                          let stepsUids = data["stepsUids"] as? [String] else {
                        continue
                    }

                    FirebaseManager.shared.fetchProducts(productUids: stepsUids) { allProducts, error in
                        guard let products = allProducts else {
                            if let error {
                                print(error)
                            }
                            return
                        }

                        self.products = products
                        for product in products {
                            self.favorites.removeAll { $0.productUid == product.productUid }
                        }
                        self.objectWillChange.send()
                    }
                }

                print("success fetchBarterChain")
            }
    }
}
