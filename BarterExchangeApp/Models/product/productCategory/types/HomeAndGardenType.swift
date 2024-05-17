//
//  HomeAndGardenType.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 10.02.2024.
//

enum HomeAndGardenType: String, CaseIterable, Codable {
    case furniture = "Мебель"
    case homeAppliances = "Бытовая техника"
    case homeDecor = "Декор"
    case gardenTools = "Дача и сад"

    func allCasesString() -> [String] {
        var cases: [String] = []
        for caseType in HomeAndGardenType.allCases {
            cases.append(caseType.rawValue)
        }
        return cases
    }
}
