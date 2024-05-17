//
//  SelectCityViewModel.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 09.05.2024.
//

import SwiftUI
import FirebaseFirestore

class SelectCityViewModel: ObservableObject {
    @Published var searchText: String = ""

    var isSearching: Bool {
        return !searchText.isEmpty
    }

    var filteredCities: [String] {
        guard !searchText.isEmpty else {
            return cities
        }
        return cities.filter { $0.localizedStandardContains(searchText) }
    }

    @Published private var cities: [String] = []

    init() {
        self.cities = loadCitiesFromFile()
    }

    func loadCitiesFromFile() -> [String] {
        // Определение имени файла и его расширения
        guard let filePath = Bundle.main.path(forResource: "txt-cities-russia", ofType: "txt") else {
            print("Файл не найден")
            return []
        }

        do {
            // Чтение данных из файла
            let contents = try String(contentsOfFile: filePath, encoding: .utf8)
            // Разделение строк по символу новой строки
            let cities = contents.components(separatedBy: "\n").filter { !$0.isEmpty }
            return cities
        } catch {
            print("Ошибка при чтении файла: \(error)")
            return []
        }
    }
}


