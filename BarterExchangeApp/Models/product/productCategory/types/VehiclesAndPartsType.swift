//
//  VehiclesAndPartsType.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 10.02.2024.
//

enum VehiclesAndPartsType: String, CaseIterable, Codable {
    case cars = "Машины"
    case motorcycles = "Мотоциклы"
    case bicycles = "Велосипеды"
    case carAccessories = "Запчасти"

    func allCasesString() -> [String] {
        var cases: [String] = []
        for caseType in VehiclesAndPartsType.allCases {
            cases.append(caseType.rawValue)
        }
        return cases
    }
}
