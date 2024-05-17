//
//  PetSuppliesType.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 10.02.2024.
//

enum PetSuppliesType: String, CaseIterable, Codable {
    case toys = "Игрушки"
    case accessories = "Аксессуары"
    case care = "Уход"
    case furniture = "Мебель"

    func allCasesString() -> [String] {
        var cases: [String] = []
        for caseType in PetSuppliesType.allCases {
            cases.append(caseType.rawValue)
        }
        return cases
    }
}
