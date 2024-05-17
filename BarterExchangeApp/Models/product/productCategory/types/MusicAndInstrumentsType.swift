//
//  MusicAndInstrumentsType.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 10.02.2024.
//

enum MusicAndInstrumentsType: String, CaseIterable, Codable {
    case guitars = "Струнные"
    case piano = "Клавишные"
    case drums = "Ударные"
    case vinyl = "Винил"
    case CDs = "Диски и касеты"

    func allCasesString() -> [String] {
        var cases: [String] = []
        for caseType in MusicAndInstrumentsType.allCases {
            cases.append(caseType.rawValue)
        }
        return cases
    }
}
