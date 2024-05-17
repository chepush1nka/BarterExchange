//
//  BarterChainsViewModels.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 12.05.2024.
//

import SwiftUI
import FirebaseFirestore

enum SelectProductMode {
    case chains
    case offer
}

class SelectProductViewModel: ObservableObject {
    var getFavorites: () -> [Product]

    @Published var products: [Product] = []
    @Published var selectedProduct: Product?
    @Published var shoudOpenChains = false

    init(getFavorites: @escaping () -> [Product]) {
        self.getFavorites = getFavorites
        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchProducts()
        }
    }

    func fetchProducts() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            print("Could not find firebase uid")
            return
        }
        
        FirebaseManager.shared.fetchProducts(uid: uid) { allProducts, error in
            guard let products = allProducts else {
                if let error {
                    print(error)
                }
                return
            }

            self.products = products
            self.objectWillChange.send()
        }
    }
}
