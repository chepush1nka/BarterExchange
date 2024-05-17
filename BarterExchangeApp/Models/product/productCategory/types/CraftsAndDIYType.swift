//
//  CraftsAndDIY.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 10.02.2024.
//

enum CraftsAndDIYType: String, CaseIterable, Codable {
    case craftTools = "Ремесленные инструменты"
    case handmadeGoods = "Изделия ручной работы"

    func allCasesString() -> [String] {
        var cases: [String] = []
        for caseType in CraftsAndDIYType.allCases {
            cases.append(caseType.rawValue)
        }
        return cases
    }
}
