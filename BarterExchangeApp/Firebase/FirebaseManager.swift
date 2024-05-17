//
//  FirebaseService.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 29.04.2024.
//

import Firebase
import FirebaseStorage
import FirebaseFirestore

class FirebaseManager: NSObject {

    let auth: Auth
    let storage: Storage
    let firestore: Firestore

    static let shared = FirebaseManager()

    override init() {
        FirebaseApp.configure()

        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()

        super.init()
    }

    func fetchProducts(completion: @escaping ([Product]?, Error?) -> Void) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            print("Could not find firebase uid")
            completion([], nil)
            return
        }

        FirebaseManager.shared.firestore
            .collection("products")
            .whereField("userUid", isNotEqualTo: uid)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    completion(nil, error)
                    return
                }

                var products: [Product] = []

                for document in snapshot!.documents {
                    let data = document.data()
                    guard
                        let productUid = data["productUid"] as? String,
                        let userUid = data["userUid"] as? String,
                        let title = data["title"] as? String,
                        let description = data["description"] as? String,
                        let productImageUrls = data["productImageUrls"] as? [String],
                        let type = data["type"] as? String,
                        let subtype = data["subtype"] as? String,
                        let condition = data["condition"] as? String,
                        let timestamp = data[FirebaseConstants.timestamp] as? Timestamp,
                        let location = data["location"] as? String
                    else {
                        continue
                    }

                    let isClosed: Bool = data["isClosed"] as? Bool ?? false

                    let product = Product(
                        productUid: productUid,
                        userUid: userUid,
                        title: title,
                        description: description,
                        productImageUrls: productImageUrls,
                        type: type,
                        subtype: subtype,
                        condition: condition,
                        timestamp: timestamp,
                        location: location,
                        isClosed: isClosed
                    )

                    products.append(product)
                }

                products = products.filter { $0.isClosed != true }

                completion(products, nil)
            }
    }

    func fetchProducts(uid: String, completion: @escaping ([Product]?, Error?) -> Void) {
        firestore
            .collection("products")
            .whereField("userUid", isEqualTo: uid)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    completion(nil, error)
                    return
                }

                var products: [Product] = []

                for document in snapshot!.documents {
                    let data = document.data()
                    guard
                        let productUid = data["productUid"] as? String,
                        let userUid = data["userUid"] as? String,
                        let title = data["title"] as? String,
                        let description = data["description"] as? String,
                        let productImageUrls = data["productImageUrls"] as? [String],
                        let type = data["type"] as? String,
                        let subtype = data["subtype"] as? String,
                        let condition = data["condition"] as? String,
                        let timestamp = data[FirebaseConstants.timestamp] as? Timestamp,
                        let location = data["location"] as? String
                    else {
                        continue
                    }

                    let isClosed: Bool = data["isClosed"] as? Bool ?? false

                    let product = Product(
                        productUid: productUid,
                        userUid: userUid,
                        title: title,
                        description: description,
                        productImageUrls: productImageUrls,
                        type: type,
                        subtype: subtype,
                        condition: condition,
                        timestamp: timestamp,
                        location: location,
                        isClosed: isClosed
                    )

                    products.append(product)
                }

                products = products.filter { $0.isClosed != true }

                completion(products, nil)
            }
    }

    func fetchClosedProducts(uid: String, completion: @escaping ([Product]?, Error?) -> Void) {
        firestore
            .collection("products")
            .whereField("userUid", isEqualTo: uid)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    completion(nil, error)
                    return
                }

                var products: [Product] = []

                for document in snapshot!.documents {
                    let data = document.data()
                    guard
                        let productUid = data["productUid"] as? String,
                        let userUid = data["userUid"] as? String,
                        let title = data["title"] as? String,
                        let description = data["description"] as? String,
                        let productImageUrls = data["productImageUrls"] as? [String],
                        let type = data["type"] as? String,
                        let subtype = data["subtype"] as? String,
                        let condition = data["condition"] as? String,
                        let timestamp = data[FirebaseConstants.timestamp] as? Timestamp,
                        let location = data["location"] as? String
                    else {
                        continue
                    }

                    let isClosed: Bool = data["isClosed"] as? Bool ?? false

                    let product = Product(
                        productUid: productUid,
                        userUid: userUid,
                        title: title,
                        description: description,
                        productImageUrls: productImageUrls,
                        type: type,
                        subtype: subtype,
                        condition: condition,
                        timestamp: timestamp,
                        location: location,
                        isClosed: isClosed
                    )

                    products.append(product)
                }

                products = products.filter { $0.isClosed == true }

                completion(products, nil)
            }
    }

    func fetchProducts(productUids: [String], completion: @escaping ([Product]?, Error?) -> Void) {
        guard !productUids.isEmpty else {
            completion([], nil)
            return
        }

        FirebaseManager.shared.firestore
            .collection("products")
            .whereField("productUid", in: productUids)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    completion(nil, error)
                    return
                }

                var products: [Product] = []

                for document in snapshot?.documents ?? [] {
                    let data = document.data()
                    guard
                        let productUid = data["productUid"] as? String,
                        let userUid = data["userUid"] as? String,
                        let title = data["title"] as? String,
                        let description = data["description"] as? String,
                        let productImageUrls = data["productImageUrls"] as? [String],
                        let type = data["type"] as? String,
                        let subtype = data["subtype"] as? String,
                        let condition = data["condition"] as? String,
                        let timestamp = data[FirebaseConstants.timestamp] as? Timestamp,
                        let location = data["location"] as? String
                    else {
                        continue
                    }

                    let isClosed: Bool = data["isClosed"] as? Bool ?? false

                    let product = Product(
                        productUid: productUid,
                        userUid: userUid,
                        title: title,
                        description: description,
                        productImageUrls: productImageUrls,
                        type: type,
                        subtype: subtype,
                        condition: condition,
                        timestamp: timestamp,
                        location: location,
                        isClosed: isClosed
                    )

                    products.append(product)
                }

                products = products.filter { $0.isClosed != true }

                completion(products, nil)
            }
    }
}
