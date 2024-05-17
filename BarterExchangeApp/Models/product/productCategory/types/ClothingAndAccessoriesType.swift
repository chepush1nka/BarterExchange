//
//  ClothingAndAccessoriesTypes.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 10.02.2024.
//

enum ClothingAndAccessoriesType: String, CaseIterable, Codable {
    case dresses = "Одежда"
    case coats = "Верхняя одежда"
    case shoes = "Обувь"
    case bags = "Сумки"
    case jewelry = "Украшения"

    func allCasesString() -> [String] {
        var cases: [String] = []
        for caseType in ClothingAndAccessoriesType.allCases {
            cases.append(caseType.rawValue)
        }
        return cases
    }
}
