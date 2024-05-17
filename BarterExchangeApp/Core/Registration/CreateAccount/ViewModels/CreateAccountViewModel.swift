//
//  CreateAccountViewModel.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 28.04.2024.
//

import SwiftUI
import Firebase

class CreateAccountViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var loginStatusMessage: String = ""

    @Published var shouldNavigate: Bool = false

    func handleAction() {
        loginStatusMessage = ""
        createAccount()
    }

    private func createAccount() {
        guard email.range(of: #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$"#, options: .regularExpression) != nil else {
            self.loginStatusMessage = "Введена некорректная почта. Пример: example@gmail.com"
            return
        }
        guard password.count > 5 else {
            self.loginStatusMessage = "Пароль должен состоять минимум из 6ти символов"
            return
        }
        guard password.count < 21 else {
            self.loginStatusMessage = "Пароль не может быть длиннее 20ти символов"
            return
        }
        if password != confirmPassword {
            self.loginStatusMessage = "Пароли не совпадают"
            return
        }
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, error in
            if let error {
                print("Failed to create user: ", error)
                self.loginStatusMessage = "Failed to create user: \(error)"
                return
            }

            print("Successfily created user: \(result?.user.uid ?? "")")
            self.shouldNavigate = true
        }
    }
}

