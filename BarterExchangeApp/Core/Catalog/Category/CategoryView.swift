//
//  CategoryView.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 10.05.2024.
//

import SwiftUI

import Foundation
import SwiftUI
import MapKit

struct CategoryView: View {
    @ObservedObject private var viewModel: CategoryViewModel
    @Namespace var animation

    var cancel: () -> ()

    init(category: String, getFavorites: @escaping () -> [Product], cancel: @escaping () -> ()) {
        self.cancel = cancel
        viewModel = CategoryViewModel(getFavorites: getFavorites, category: category)
    }

    var column = [GridItem(.adaptive(minimum: 160), spacing: 20)]

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button {
                        self.cancel()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                                .foregroundStyle(.black)
                                .imageScale(.large)
                                .foregroundStyle(.tint)
                            Text("Назад")
                        }
                    }

                    Spacer()
                }
                .padding(.horizontal)

                ScrollView {
                    ZStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .padding(.leading, 8)

                            TextField("Поиск", text: $viewModel.searchText)
                                .foregroundColor(.primary)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 4)

                            if !viewModel.searchText.isEmpty {
                                Button(action: {
                                    viewModel.searchText = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 8)
                                }
                            }
                        }
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.leading)
                        .padding(.trailing, 60)
                        filterButton
                            .padding(.leading)
                    }

                    if viewModel.filteredProducts.isEmpty {
                        Text("Ничего не нашлось")
                            .font(.headline)
                    } else {
                        LazyVGrid(columns: column, spacing: 20) {
                            ForEach(viewModel.filteredProducts, id: \.productUid) { product in
                                NavigationLink(value: product) {
                                    ProductCard(product: product)
                                }
                            }
                        }
                        .padding()
                    }
                }
                .navigationDestination(for: Product.self) { product in
                    ProductDetailView(product: product, getFavorites: viewModel.getFavorites)
                }
            }
        }
    }


    var filterButton: some View {
        HStack {
            Spacer()
            NavigationLink(destination: FiltersView(callback: { filter in
                viewModel.filter = filter
            }, viewModel: FiltersViewModel(filter: viewModel.filter))) {
                Image(systemName: "line.3.horizontal.decrease")
            }
        }
        .padding()
    }
}
