//
//  User.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 29.02.2024.
//

struct User {
    let uid, name, location, phoneNumber, profileImageUrl: String
    let averageRating: Double
    let ratingsCount: Int

    init(data: [String: Any]) {
        self.uid = data["uid"] as? String ?? ""
        self.name = data["name"] as? String ?? ""
        self.location = data["location"] as? String ?? ""
        self.phoneNumber = data["phoneNumber"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
        self.averageRating = data["averageRating"] as? Double ?? 0
        self.ratingsCount = data["ratingsCount"] as? Int ?? 0
    }

    init(uid: String, name: String, location: String, phoneNumber: String, profileImageUrl: String, averageRating: Double, ratingsCount: Int) {
        self.uid = uid
        self.name = name
        self.location = location
        self.phoneNumber = phoneNumber
        self.profileImageUrl = profileImageUrl
        self.averageRating = averageRating
        self.ratingsCount = ratingsCount
    }
}
