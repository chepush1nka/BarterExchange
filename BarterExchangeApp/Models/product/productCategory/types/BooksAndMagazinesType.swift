//
//  BooksAndMagazines.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 10.02.2024.
//

enum BooksAndMagazinesType: String, CaseIterable, Codable {
    case textbooks = "Книги"
    case comics = "Комиксы"
    case magazines = "Журналы"

    func allCasesString() -> [String] {
        var cases: [String] = []
        for caseType in BooksAndMagazinesType.allCases {
            cases.append(caseType.rawValue)
        }
        return cases
    }
}
