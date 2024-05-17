//
//  TextFieldStyle.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 27.04.2024.
//

import SwiftUI

struct CustomTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .padding(.horizontal, 16)
            .frame(minWidth: 0,
                   maxWidth: .infinity)
            .frame(height: 56)
            .background(
                Color(UIColor.systemGray5)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            )
            .foregroundStyle(.black)
    }
}

extension View {
    func customTextFieldStyle() -> some View {
        self.modifier(CustomTextFieldStyle())
    }
}

