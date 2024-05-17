//
//  ProductView.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 31.01.2024.
//

import Foundation
import SwiftUI
import MapKit

struct ExploreView: View {
    @ObservedObject private var viewModel: ExploreViewModel
    @Namespace var animation

    init(getFavorites: @escaping () -> [Product]) {
        viewModel = ExploreViewModel(getFavorites: getFavorites)
    }

    //    @State private var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(
    //        center: CLLocationCoordinate2D(latitude: 55.7522, longitude: 37.6156), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))

    var column = [GridItem(.adaptive(minimum: 160), spacing: 20)]

    var body: some View {
        NavigationStack {
            ScrollView {

                if !viewModel.isSearching {
                    barterChainView
                        .padding(.horizontal)
                        .padding(.top)

                    //                    Map(position: $cameraPosition)
                    //                        .frame(height: 126)
                    //                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    //                        .padding(.horizontal)
                    //                        .padding(.top, 10)
                    //                        .padding(.bottom)
                } else {
                    filterButton
                }

                exploreFilterBar
                    .padding(.horizontal)

                LazyVGrid(columns: column, spacing: 20) {
                    ForEach(viewModel.filteredProducts, id: \.productUid) { product in
                        NavigationLink(value: product) {
                            ProductCard(product: product)
                        }
                    }
                }
                .padding()
            }
            .refreshable {
                viewModel.fetchProducts()
            }
            .navigationDestination(for: Product.self) { product in
                ProductDetailView(product: product, getFavorites: viewModel.getFavorites)
            }
            .navigationDestination(for: Int.self) { _ in
                SelectProductView(viewModel: SelectProductViewModel(getFavorites: viewModel.getFavorites), mode: .chains)
            }
        }
        .searchable(text: $viewModel.searchText, prompt: "Поиск")
        .searchSuggestions {
            ForEach(viewModel.filteredSuggestions, id: \.self) { suggestion in
                Text(suggestion)
                    .searchCompletion(suggestion)
            }
        }
    }

    var filterButton: some View {
        HStack {
            Spacer()
            NavigationLink(destination: FiltersView(callback: { filter in
                viewModel.filter = filter
            }, viewModel: FiltersViewModel(filter: viewModel.filter))) {
                HStack {
                    Text("Фильтры")
                    Image(systemName: "line.3.horizontal.decrease")
                }
            }
        }
        .padding()
    }

    var barterChainView: some View {
        NavigationLink(value: 1) {
            VStack {
                HStack {
                    Text("Составь свою цепочку обмена")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                        .padding(.horizontal)
                    Spacer()
                }
                HStack {
                    Text("Мы сделали удобное пространство, где ты можешь планировать свои обмены, чтобы получить желаемое")
                        .padding(.horizontal)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                HStack {
                    Image("guitar")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 65, height: 65)
                        .clipShape(Circle())
                        .padding([.leading, .top, .bottom])
                    Rectangle()
                        .fill(Color.gray)
                        .frame(height: 2)
                        .padding(.horizontal, -9)
                    Image("lg")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 65, height: 65)
                        .clipShape(Circle())
                        .padding([.top, .bottom])
                    Rectangle()
                        .fill(Color.gray)
                        .frame(height: 2)
                        .padding(.horizontal, -9)
                    Image("iphone")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 65, height: 65)
                        .clipShape(Circle())
                        .padding([.top, .bottom])
                    Rectangle()
                        .fill(Color.gray)
                        .frame(height: 2)
                        .padding(.horizontal, -9)
                    Image("note")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 65, height: 65)
                        .clipShape(Circle())
                        .padding([.top, .bottom, .trailing])
                }
            }
            .frame(minWidth: 0,
                               maxWidth: .infinity)
            .background(Color(red: 217/255, green: 247/255, blue: 23/255))
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .padding(.bottom)
    }

    var exploreFilterBar: some View {
        HStack {
            ForEach(ExploreFilterScopes.allCases, id: \.rawValue) { item in
                VStack {
                    Text(item.title)
                        .font(.subheadline)
                        .fontWeight(viewModel.selectedFilter == item ? .semibold : .regular)
                        .foregroundStyle(viewModel.selectedFilter == item ? .black : .gray)
                    if viewModel.selectedFilter == item {
                        Capsule()
                            .foregroundStyle(.black)
                            .frame(height: 3)
                            .matchedGeometryEffect(id: "filter", in: animation)
                    } else {
                        Capsule()
                            .foregroundStyle(.clear)
                            .frame(height: 3)
                    }
                }
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        self.viewModel.selectedFilter = item
                    }
                }
            }
        }
        .overlay(Divider().offset(x: 0, y: 16))
    }
}
