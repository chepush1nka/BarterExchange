//
//  RegistrationView.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 26.04.2024.
//

import SwiftUI

struct RegistrationRootView: View {

    var didCompleteLogIn: () -> ()

    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink(destination: LoginView(didCompleteLogIn: didCompleteLogIn)) {
                    Text("Войти")
                        .mainButtonStyle()
                        .padding(.horizontal)
                }
                NavigationLink(destination: CreateAccountView(didCompleteLogIn: didCompleteLogIn)) {
                    Text("Создать аккаунт")
                        .mainButtonStyle()
                        .padding(.horizontal)
                }
            }
        }
        //.navigationTitle("Создайте аккаунт")
    }
}

#Preview {
    RegistrationRootView(didCompleteLogIn: {
        print("didCompleteLogIn")
    })
}
