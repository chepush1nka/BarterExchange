//
//  CreateAccountView.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 27.04.2024.
//

import SwiftUI

struct CreateAccountView: View {

    @StateObject private var viewModel: CreateAccountViewModel = CreateAccountViewModel()
    var didCompleteLogIn: () -> ()

    var body: some View {
        NavigationStack {
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
                    .padding(.bottom, 40)

                Text("Пароль")
                    .padding(.leading)
                    .font(.callout)
                SecureField("Введите пароль", text: $viewModel.password)
                    .customTextFieldStyle()

                SecureField("Подтвердите пароль", text: $viewModel.confirmPassword)
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
            .navigationDestination(isPresented: $viewModel.shouldNavigate) {
                ProfileInfoView(didCompleteLogIn: didCompleteLogIn)
            }
        }
    }
}

#Preview {
    CreateAccountView(didCompleteLogIn: {
        print("didCompleteLogIn")
    })
}
