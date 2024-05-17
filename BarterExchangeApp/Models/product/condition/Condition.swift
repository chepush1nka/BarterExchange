//
//  Condition.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 14.04.2024.
//

enum Condition: String, Hashable, CaseIterable, Codable {
    case new = "Новый"
    case perfect = "Отличное"
    case normal = "Нормальное"
    case bad = "Плохое"

    static func allCasesString() -> [String] {
        var cases: [String] = []
        for caseType in Condition.allCases {
            cases.append(caseType.rawValue)
        }
        return cases
    }

    static func mapToCondition(from condition: String) -> Condition {
        for caseCondition in Condition.allCases {
            if caseCondition.rawValue == condition {
                return caseCondition
            }
        }
        return .normal
    }

}
