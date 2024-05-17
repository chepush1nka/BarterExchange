//
//  ProfileInfoViewModel.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 30.04.2024.
//

import SwiftUI
import Firebase

class ProfileInfoViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var name: String = ""
    @Published var town: String = "Выберите город"
    @Published var number: String = ""

    @Published var shouldShowImagePicker = false
    @Published var existingUser: User?
    @Published var showSearchCity = false

    @Published var statusLabel: String = ""

    var didCompleteLogIn: () -> ()

    init(didCompleteLogIn: @escaping () -> Void, user: User?) {
        self.didCompleteLogIn = didCompleteLogIn
        self.existingUser = user
        if let currUser = existingUser {
            self.name = currUser.name
            self.number = currUser.phoneNumber
            self.town = currUser.location.isEmpty ? "Выберите город" : currUser.location
        }
    }

    func handleImageAction() {
        shouldShowImagePicker = true
    }

    func saveUserInfo() -> Bool {
        if self.image != nil {
            if !name.isEmpty {
                if town != "Выберите город" {
                    return persistImageToStorage()
                } else {
                    statusLabel = "Пожалуйста, укажите ваш город"
                }
            } else {
                statusLabel = "Пожалуйста, введите ваше имя"
            }
        } else if let existingUser {
            return persistImageToStorage()
        } else {
            statusLabel = "Пожалуйста, добавьте изображение профиля"
        }
        return false
    }

    private func persistImageToStorage() -> Bool {
        guard image != nil else {
            if let user = existingUser {
                return self.storeUserInformation(url: user.profileImageUrl)
            }
            statusLabel = "Пожалуйста, добавьте изображение профиля"
            return false
        }
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid,
              let imageData = self.image?.jpegData(compressionQuality: 0.5) else {
            return false
        }
        let reference = FirebaseManager.shared.storage.reference(withPath: uid)
        var result = false
        reference.putData(imageData) { metadata, error in
            if let error {
                print(error)
                return
            }
            reference.downloadURL { url, error in
                if let error {
                    print(error)
                    return
                }
                guard let url else { return }
                result = self.storeUserInformation(url: url.absoluteString)
            }
        }

        return result
    }

    func storeUserInformation(url: String) -> Bool {
        statusLabel = ""
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            return false
        }
        let userData = [
            "uid": uid,
            "name": name,
            "phoneNumber": number,
            "location": town,
            "profileImageUrl": url,
            "averageRating": Double(0.0),
            "ratingsCount": Int(0)
        ] as [String : Any]
        var err: Error?
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).setData(userData) { error in
                if let err = error {
                    print(err)
                    return
                }
                print("success storeUserInformation")
                self.didCompleteLogIn()
                return
            }
        if err == nil {
            return true
        }
        return false
    }
}
