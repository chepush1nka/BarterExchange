//
//  SellerViewModel.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 09.05.2024.
//

import SwiftUI
import FirebaseFirestore

class SellerViewModel: ObservableObject {
    @Published var selectedFilter: SellerFilterViewModel = .sells
    @Published var user: User
    @Published var currrentRate: Int = 0
    @Published var products: [Product] = []
    @Published var closedProducts: [Product] = []

    @Published var shoulShowRateProfile = false

    var getFavorites: () -> [Product]

    init(seller: User, getFavorites: @escaping () -> [Product]) {
        self.getFavorites = getFavorites
        self.user = seller
        DispatchQueue.global(qos: .userInitiated).async {
            FirebaseManager.shared.fetchProducts(uid: seller.uid) { allProducts, error in
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
            self.fetchRating(to: seller.uid, completion: { rate in
                guard let curRate = rate else {
                    return
                }
                self.currrentRate = curRate
            })
        }
    }

    func rateSeller() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            print("Could not find firebase uid")
            return
        }

        addRating(to: user.uid, from: uid, rating: currrentRate)
    }

    func fetchRating(to userId: String, completion: @escaping (Int?) -> Void) {
        guard let raterId = FirebaseManager.shared.auth.currentUser?.uid else {
            print("Could not find firebase uid")
            return
        }

        let db = Firestore.firestore()
        let ratingRef = db.collection("users").document(userId).collection("ratings").document(raterId)

        ratingRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let ratingValue = document.data()?["ratingValue"] as? Int
                completion(ratingValue)
            } else {
                print("Rating does not exist")
                completion(nil)
            }
        }
    }


    private func addRating(to userId: String, from raterId: String, rating: Int) {
        let db = Firestore.firestore()
        let userRatingsRef = db
            .collection("users")
            .document(userId)
            .collection("ratings")
            .document(raterId)

        // Проверяем, существует ли уже оценка от этого пользователя
        userRatingsRef.getDocument { (document, error) in
            userRatingsRef.setData([
                "ratingValue": rating,
                "timestamp": FieldValue.serverTimestamp()
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document successfully added!")
                    self.updateAverageRating(userId: userId) // Обновляем средний рейтинг
                }
            }
        }
    }

    private func updateAverageRating(userId: String) {
        let db = Firestore.firestore()
        let userRef = db
            .collection("users")
            .document(userId)

        let ratingsRef = userRef.collection("ratings")

        ratingsRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let total = querySnapshot!.documents.reduce(0) { (total, document) -> Int in
                    let ratingValue = document.data()["ratingValue"] as! Int
                    return total + ratingValue
                }
                let count = querySnapshot!.documents.count
                let averageRating = Double(total) / Double(count)

                userRef
                    .updateData([
                        "averageRating": averageRating,
                        "ratingsCount": count
                    ])
            }
        }
    }
}

enum SellerFilterViewModel: Int, CaseIterable {
    case sells
    case concluded

    var title: String {
        switch self {
        case .sells:
            "Объявления"
        case .concluded:
            "Завершенные"
        }
    }
}
