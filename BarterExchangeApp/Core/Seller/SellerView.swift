//
//  SellerView.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 09.05.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct SellerView: View {
    @Namespace var animation

    @ObservedObject private var viewModel: SellerViewModel

    private var column = [GridItem(.adaptive(minimum: 160), spacing: 20)]

    private let fallback: (Product) -> ()

    init(seller: User, getFavorites: @escaping () -> [Product], fallback: @escaping (Product) -> ()) {
        self.fallback = fallback
        viewModel = SellerViewModel(seller: seller, getFavorites: getFavorites)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    HStack {
                        WebImage(url: URL(string: viewModel.user.profileImageUrl)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 71, height: 71)
                        .background(Color(UIColor.systemGray5))
                        .clipShape(Circle())
                        VStack(alignment: .leading, spacing: 4) {
                            Text(viewModel.user.name)
                                .font(.title3)
                                .frame(width: 250, alignment: .leading)
                            Text("\(String(format: "%.1f", viewModel.user.averageRating)) ☆ Отзывов: \(viewModel.user.ratingsCount)")
                            Text("Oбъявлений: \(viewModel.products.count)")
                        }
                        Spacer()
                    }
                    .padding()
                    Button {
                        viewModel.shoulShowRateProfile.toggle()
                    } label: {
                        Text("Оценить профиль")
                            .mainButtonStyle()
                    }
                    .padding(.horizontal)

                    profileFilterBar
                        .padding(.horizontal)
                    if viewModel.selectedFilter == .sells {
                        LazyVGrid(columns: column, spacing: 20) {
                            ForEach(viewModel.products, id: \.productUid) { product in
                                Button {
                                    self.fallback(product)
                                } label: {
                                    ProductCard(product: product)
                                }
                            }
                        }
                        .padding()
                    } else {
                        LazyVGrid(columns: column, spacing: 20) {
                            ForEach(viewModel.closedProducts, id: \.productUid) { product in
                                Button {
                                    self.fallback(product)
                                } label: {
                                    ProductCard(product: product)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        //shouldShowLogOutOptions.toggle()
                    }) {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.degrees(90))
                            .foregroundStyle(.black)
                    }
                }
            }
            .sheet(isPresented: $viewModel.shoulShowRateProfile, content: {
                rateProfileBar
                    .presentationDetents([.fraction(0.3)])
                    .padding()
            })
//            .actionSheet(isPresented: $shouldShowLogOutOptions) {
//                .init(title: Text("Настройки"), message: Text("Что вы хотите сделать?"), buttons: [
//                    .destructive(Text("Выйти"), action: {
//                        viewModel.handleSignOut()
//                    }),
//                        .cancel()
//                ])
//            }
        }
    }

    var rateProfileBar: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("Оцените профиль")
                .font(.headline)
            Spacer()
            HStack(alignment: .center, spacing: 10) {
                ForEach(1..<6) { i in
                    Image(systemName: "star.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(self.viewModel.currrentRate >= i ? Color(red: 217/255, green: 247/255, blue: 23/255) : Color(.systemGray5))
                        .onTapGesture {
                            self.viewModel.currrentRate = i
                        }
                }
            }
            Spacer()
            Button {
                viewModel.rateSeller()
                viewModel.shoulShowRateProfile = false
            } label: {
                Text("Отправить")
                    .mainButtonStyle()
            }
        }
    }

    var profileFilterBar: some View {
        HStack {
            ForEach(SellerFilterViewModel.allCases, id: \.rawValue) { item in
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
