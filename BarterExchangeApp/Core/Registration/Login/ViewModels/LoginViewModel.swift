//
//  LoginViewModel.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 29.04.2024.
//

import SwiftUI
import Firebase

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var loginStatusMessage: String = ""

    var didCompleteLogIn: () -> ()

    init(didCompleteLogIn: @escaping () -> Void) {
        self.didCompleteLogIn = didCompleteLogIn
    }

    func handleAction() {
        login()
    }

    private func login() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, error in
            if let error {
                print("Failed to login user: ", error)
                self.loginStatusMessage = "Не удалось совершить вход. Проверьте корректность логина и пароля"
                return
            }

            print("Successfily logged in as user: \(result?.user.uid ?? "")")
            self.didCompleteLogIn()
        }
    }
}
