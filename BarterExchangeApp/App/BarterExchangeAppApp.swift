//
//  BarterExchangeAppApp.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 31.01.2024.
//

import SwiftUI
import Firebase

@main
struct BarterExchangeAppApp: App {

    @State var loginStatus: Bool = (FirebaseManager.shared.auth.currentUser != nil)

    var body: some Scene {
        WindowGroup {
            if loginStatus {
                MainTabView(didLogOut: {
                    loginStatus = false
                })
            } else {
                RegistrationRootView(didCompleteLogIn: {
                    loginStatus = true
                })
                .tint(.black)
            }
        }
    }
}
