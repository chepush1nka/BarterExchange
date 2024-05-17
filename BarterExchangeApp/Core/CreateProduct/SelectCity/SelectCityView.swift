//
//  nso.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 09.05.2024.
//

import SwiftUI

struct SelectCityView: View {

    let callback: (String) -> ()

    @ObservedObject var viewModel: SelectCityViewModel = SelectCityViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.filteredCities, id: \.self) { city in
                Button {
                    viewModel.searchText = city
                    callback(city)
                } label: {
                    Text(city)
                        .foregroundStyle(.black)
                }
            }
        }
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Поиск")
    }
}

struct SelectCityView_Previews: PreviewProvider {
    static var previews: some View {
        SelectCityView { str in
            print(str)
        }
    }
}

