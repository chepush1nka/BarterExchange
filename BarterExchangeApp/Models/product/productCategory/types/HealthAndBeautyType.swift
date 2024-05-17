//
//  HealthAndBeautyType.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 10.02.2024.
//

enum HealthAndBeautyType: String, CaseIterable, Codable {
    case makeup = "Косметика"
    case skincare = "Уход за кожей"
    case haircare = "Уход за волосами"
    case parfume = "Парфюмерия"
    case wellnessGadgets = "Устройства для оздоровления"

    func allCasesString() -> [String] {
        var cases: [String] = []
        for caseType in HealthAndBeautyType.allCases {
            cases.append(caseType.rawValue)
        }
        return cases
    }
}
