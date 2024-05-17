//
//  CatalogView.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 22.04.2024.
//

import SwiftUI

struct CatalogView: View {
    @StateObject private var viewModel: CatalogViewModel = CatalogViewModel()

    let getFavorites: () -> [Product]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(viewModel.filteredCategories, id: \.self) { category in
                        Button {
                            viewModel.filters.selectedCategory = category.toString()
                            viewModel.showCategoryView.toggle()
                        } label: {
                            HStack {
                                Image(category.toString())
                                    .resizable()
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .padding(.vertical, 8)
                                    .padding(.leading, 8)
                                    .frame(width: 192)
                                Spacer()
                                Text(category.toString())
                                    .padding(.trailing)
                                Spacer()
                            }
                            .frame(minWidth: 0,
                                   maxWidth: .infinity)
                            .frame(height: 126)
                            .background(Color(red: 233/255, green: 235/255, blue: 240/255))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .foregroundStyle(.black)
                            .padding(.horizontal)
                        }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.showCategoryView, content: {
            CategoryView(category: viewModel.filters.selectedCategory ?? "", getFavorites: getFavorites, cancel: {
                self.viewModel.showCategoryView = false
            })
        })
        .searchable(text: $viewModel.searchText, prompt: "Поиск")
        .searchSuggestions {
            ForEach(viewModel.filteredSuggestions, id: \.self) { suggestion in
                Text(suggestion)
                    .searchCompletion(suggestion)
            }
        }
    }
}
