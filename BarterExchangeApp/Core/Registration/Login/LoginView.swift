//
//  LoginView.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 29.04.2024.
//

import SwiftUI

struct LoginView: View {

    var didCompleteLogIn: () -> ()
    @ObservedObject private var viewModel: LoginViewModel

    init(didCompleteLogIn: @escaping () -> Void) {
        self.didCompleteLogIn = didCompleteLogIn
        self.viewModel = LoginViewModel(didCompleteLogIn: didCompleteLogIn)
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10) {
                Spacer()
                Text(viewModel.loginStatusMessage)
                    .foregroundStyle(.red)
                Text("Почта")
                    .padding(.leading)
                    .font(.callout)
                TextField("Введите вашу электронную почту", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .customTextFieldStyle()
                    .padding(.bottom)

                Text("Пароль")
                    .padding(.leading)
                    .font(.callout)
                SecureField("Введите пароль", text: $viewModel.password)
                    .customTextFieldStyle()

                Spacer()
                Button {
                    viewModel.handleAction()
                } label: {
                    Text("Продолжить")
                        .mainButtonStyle()
                }
            }
            .padding()
        }
    }
}

#Preview {
    LoginView(didCompleteLogIn: {
        print("didCompleteLogIn")
    })
}
