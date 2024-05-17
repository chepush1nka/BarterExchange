//
//  Electronics.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 10.02.2024.
//

enum ElectronicsType: String, CaseIterable, Codable {
    case smartphones = "Сматрфоны"
    case TVs = "Телевизоры"
    case laptops = "Ноутбуки"
    case cameras = "Камеры"
    case headphones = "Наушники"

    func allCasesString() -> [String] {
        var cases: [String] = []
        for caseType in ElectronicsType.allCases {
            cases.append(caseType.rawValue)
        }
        return cases
    }
}
