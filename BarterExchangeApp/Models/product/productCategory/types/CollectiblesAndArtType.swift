//
//  CollectiblesAndArtType.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 10.02.2024.
//

enum CollectiblesAndArtType: String, CaseIterable, Codable {
    case coins = "Монеты"
    case stamps = "Марки"
    case artwork = "Искусство"
    case antiques = "Антиквариат"

    func allCasesString() -> [String] {
        var cases: [String] = []
        for caseType in CollectiblesAndArtType.allCases {
            cases.append(caseType.rawValue)
        }
        return cases
    }
}
