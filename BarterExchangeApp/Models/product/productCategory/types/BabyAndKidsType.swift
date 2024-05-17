//
//  BabyAndKidsType.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 10.02.2024.
//

enum BabyAndKidsType: String, CaseIterable, Codable {
    case childrensClothing = "Детская одежда"
    case strollers = "Коляски"
    case toys = "Игрушки"
    case furniture = "Мебель"
    case books = "Книги"

    func allCasesString() -> [String] {
        var cases: [String] = []
        for caseType in BabyAndKidsType.allCases {
            cases.append(caseType.rawValue)
        }
        return cases
    }
}
