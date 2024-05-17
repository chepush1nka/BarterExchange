//
//  MessageView.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 06.05.2024.
//

import SwiftUI

struct MessageView: View {

    let message: ChatMessage

    var body: some View {
        VStack {
            if message.fromId == FirebaseManager.shared.auth.currentUser?.uid {
                HStack {
                    Spacer()
                    HStack {
                        Text(message.text)
                            .foregroundColor(.black)
                    }
                    .padding()
                    .background(Color(red: 217/255, green: 247/255, blue: 23/255))
                    .cornerRadius(20)
                }
            } else {
                HStack {
                    HStack {
                        Text(message.text)
                            .foregroundColor(.black)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    Spacer()
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}
