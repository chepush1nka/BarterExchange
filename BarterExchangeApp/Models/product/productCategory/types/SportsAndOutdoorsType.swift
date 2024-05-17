//
//  SportsAndOutdoorsTypes.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 10.02.2024.
//

enum SportsAndOutdoorsType: String, CaseIterable, Codable {
    case fitnessEquipment = "Фитнес и йога"
    case campingGear = "Туризм и рыбалка"
    case sportsApparel = "Спортивная одежда"
    case bicycles = "Велоспорт"
    case waterSport = "Водный спорт"
    case equipment = "Экипировка"

    func allCasesString() -> [String] {
        var cases: [String] = []
        for caseType in SportsAndOutdoorsType.allCases {
            cases.append(caseType.rawValue)
        }
        return cases
    }
}
