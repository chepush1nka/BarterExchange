//
//  MainButtonStyle.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 28.04.2024.
//

import SwiftUI

struct MainButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(minWidth: 0,
                   maxWidth: .infinity)
            .frame(height: 56)
            .background(Color(red: 217/255, green: 247/255, blue: 23/255))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .foregroundStyle(.black)
    }
}

extension View {
    func mainButtonStyle() -> some View {
        self.modifier(MainButtonStyle())
    }
}
