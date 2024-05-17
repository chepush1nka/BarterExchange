//
//  FiltersViewModel.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 09.05.2024.
//

import SwiftUI
import FirebaseFirestore

class FiltersViewModel: ObservableObject {
    
    @Published var filter: Filter = Filter()

    @Published var showSelectCity = false

    private var user: User = User(data: [:])

    init(filter: Filter?) {
        if let exFilter = filter {
            self.filter = exFilter
        }
        fetchCurrentUser()
    }

    func fetchCurrentUser() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            print("Could not find firebase uid")
            return
        }


        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("Failed to fetch current user: \(error)")
                return
            }

            guard let data = snapshot?.data() else {
                print("No data found")
                return

            }
            self.user = User(data: data)
        }
    }
}
