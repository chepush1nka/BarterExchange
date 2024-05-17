//
//  CategoryViewModel.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 10.05.2024.
//

import SwiftUI
import FirebaseFirestore

class CategoryViewModel: ObservableObject {
    @Published var filter: Filter? = nil
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
        var filtered: [Product] = products
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.title.localizedStandardContains(searchText) }
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

    @Published private var products: [Product] = []

    init(getFavorites: @escaping () -> [Product], category: String) {
        self.getFavorites = getFavorites
        self.filter = Filter(selectedCategory: category)
        DispatchQueue.global(qos: .userInitiated).async {
            FirebaseManager.shared.fetchProducts() { allProducts, error in
                guard let products = allProducts else {
                    if let error {
                        print(error)
                    }
                    return
                }

                self.products = products
                self.objectWillChange.send()
            }
        }
    }
}
