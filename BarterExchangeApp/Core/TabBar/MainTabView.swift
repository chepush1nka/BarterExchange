//
//  MainTabView.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 17.04.2024.
//

import SwiftUI

struct MainTabView: View {

    @ObservedObject var viewModel: MainTabViewModel = MainTabViewModel()
    @State private var selectedTab: Int = 0

    var didLogOut: () -> ()

    var body: some View {
        TabView(selection: $selectedTab) {
            ExploreView(getFavorites: {
                return viewModel.favorites
            })
            .tabItem {
                Image("BE")
            }
            .tag(0)

            CatalogView(getFavorites: {
                viewModel.favorites
            })
            .tabItem {
                Image(systemName: "rectangle.on.rectangle")
                    .environment(\.symbolVariants, .none)
            }
            .tag(1)

            CreateProductView(setTab: {
                self.selectedTab = 0
            })
            .tabItem {
                Image(systemName: "plus.circle")
                    .environment(\.symbolVariants, .none)
            }
            .tag(2)

            RootChatView()
            .tabItem {
                Image(systemName: "bubble.right")
                    .environment(\.symbolVariants, .none)
            }
            .tag(3)

            ProfileView(didLogOut: didLogOut, getFavorites: {
                viewModel.favorites
            })
            .tabItem {
                Image(systemName: "person")
                    .environment(\.symbolVariants, .none)
            }
            .tag(4)
            .navigationTitle("Мой профиль")
            .navigationBarTitleDisplayMode(.inline)
        }
        .tint(.black)
    }
}


#Preview {
    MainTabView(didLogOut: {
        print("didLogOut")
    })
}
