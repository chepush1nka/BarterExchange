//
//  ExploreViewModel.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 19.04.2024.
//

import SwiftUI
import FirebaseFirestore

class ExploreViewModel: ObservableObject {
    @Published var filter: Filter? = nil
    @Published var user: User = User(data: [:])
    @Published var searchText: String = ""
    @Published var selectedFilter: ExploreFilterScopes = .recomendations

    @Published var suggestions = ["Телевизор", "Пианино", "Игрушки", "Картина", "Гитара", "iPhone",
                                  "Монитор", "Сапоги", "Кроссовки", "Коляска",
                                  "Клавиатура", "Наушнники", "Кресло"]

    var getFavorites: () -> [Product]

    var filteredSuggestions: [String] {
        guard !searchText.isEmpty else { return suggestions }
        guard !suggestions.contains(searchText) else {return []}
        return suggestions.sorted().filter { $0.lowercased().contains(searchText.lowercased()) }
    }

    var isSearching: Bool {
        return !searchText.isEmpty
    }

    var filteredProducts: [Product] {
        guard !searchText.isEmpty else {
            //self.filter = nil
            if selectedFilter == .nearby {
                return products.filter { $0.location ==  user.location}
            } else if selectedFilter == .new {
                return products.sorted { $0.timestamp.dateValue() > $1.timestamp.dateValue() }
            }
            return products
        }
        var filtered = products.filter { $0.title.localizedStandardContains(searchText) }
        if selectedFilter == .nearby {
            filtered = filtered.filter { $0.location ==  user.location}
        } else if selectedFilter == .new {

        }
        guard let filters = filter else {
            return filtered
        }
        if let filterByLocation = filters.selectedCity {
            filtered = filtered.filter { $0.location == filterByLocation }
        }
        if let filterByCondition = filters.selectedCondition {
            filtered = filtered.filter { $0.condition.rawValue == filterByCondition }
        }
        if let filterByCategory = filters.selectedCategory {
            filtered = filtered.filter { $0.category.toString() == filterByCategory }
        }
        if let filterBySubcategory = filters.selectedSubcategory {
            filtered = filtered.filter { $0.category.toStringSubtype() == filterBySubcategory }
        }
        return filtered
    }

    @Published var products: [Product] = []

    init(getFavorites: @escaping () -> [Product]) {
        self.getFavorites = getFavorites
        DispatchQueue.global(qos: .userInitiated).async  {
            self.fetchProducts()
        }
    }

    func fetchProducts() {
        FirebaseManager.shared.fetchProducts() { allProducts, error in
            guard let products = allProducts else {
                if let error {
                    print(error)
                }
                return
            }

            self.products = products
            self.fetchCurrentUser()
            self.objectWillChange.send()
        }
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

enum ExploreFilterScopes: Int, CaseIterable {
    case recomendations
    case new
    case nearby

    var title: String {
        switch self {
        case .recomendations:
            "Рекомендации"
        case .new:
            "Новое"
        case .nearby:
            "Рядом"
        }
    }
}
