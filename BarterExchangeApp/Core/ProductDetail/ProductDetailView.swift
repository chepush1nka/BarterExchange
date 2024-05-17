//
//  ProductDetailView.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 07.04.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProductDetailView: View {

    @ObservedObject var viewModel: ProductDetailViewModel

    private let setTab: (() -> ())?

    init(product: Product, getFavorites: @escaping () -> [Product], setTab: (() -> ())? = nil) {
        self.setTab = setTab
        self.viewModel = ProductDetailViewModel(product: product, getFavorites: getFavorites)
    }

    var body: some View {
        //NavigationView {
            ScrollView {
                ZStack {
                    ProductAsyncImageCarouselView(imagesURLs: viewModel.product.productImageUrls)
                        .frame(height: 394)
                }
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(viewModel.product.title)
                            .font(.title)
                            .fontWeight(.medium)
                            .padding(.bottom)
                        Spacer()
                        if !viewModel.isOwnerLooking, !viewModel.product.isClosed {
                            Button {
                                viewModel.isFavorite.toggle()
                            } label: {
                                if viewModel.isFavorite {
                                    Image(systemName: "heart.fill")
                                        .foregroundStyle(.black)
                                        .imageScale(.large)
                                        .foregroundStyle(.tint)
                                        .padding(.trailing)
                                } else {
                                    Image(systemName: "heart")
                                        .foregroundStyle(.black)
                                        .imageScale(.large)
                                        .foregroundStyle(.tint)
                                        .padding(.trailing)
                                }
                            }
                        } else if viewModel.product.isClosed {
                            Text("Товар уже обменян")
                                .font(.headline)
                        }
                    }
                    Text("Описание")
                        .font(.headline)
                        .foregroundStyle(.gray)
                    Text(viewModel.product.description)
                        .padding(.bottom)
                    Text("Характеристики")
                        .font(.headline)
                        .foregroundStyle(.gray)
                    HStack {
                        Text("Вид товара:")
                            .font(.headline)
                            .foregroundStyle(.gray)
                        Text(viewModel.product.category.toString())
                            .font(.headline)
                            .fontWeight(.regular)
                    }
                    HStack {
                        Text("Состояние товара:")
                            .font(.headline)
                            .foregroundStyle(.gray)
                        Text(viewModel.product.condition.rawValue)
                            .font(.headline)
                            .fontWeight(.regular)
                    }
                    HStack {
                        Text("Город:")
                            .font(.headline)
                            .foregroundStyle(.gray)
                        Text(viewModel.product.location)
                            .font(.headline)
                            .fontWeight(.regular)
                    }
                    .padding(.bottom)

                    Text("Владелец")
                        .font(.headline)
                        .foregroundStyle(.gray)

                    Button {
                        if !viewModel.isOwnerLooking {
                            viewModel.showProfile.toggle()
                        }
                    } label: {
                        HStack {
                            WebImage(url: URL(string: viewModel.seller.profileImageUrl)) { image in
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
                                Text(viewModel.seller.name)
                                    .font(.title3)
                                    .frame(width: 250, alignment: .leading)
                                Text("\(String(format: "%.1f", viewModel.seller.averageRating)) ☆ Отзывов: \(viewModel.seller.ratingsCount)")
                            }
                        }
                        .padding(.bottom, 70)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .sheet(isPresented: $viewModel.showProfile) {
                SellerView(seller: viewModel.seller, getFavorites: viewModel.getFavorites) { product in
                    viewModel.product = product
                    viewModel.showProfile = false
                }
            }
            .sheet(isPresented: $viewModel.showSelectProduct) {
                SelectProductView(viewModel: SelectProductViewModel(getFavorites: {
                    return [Product(data: [:])]
                }), mode: .offer) { product in
                    self.viewModel.showSelectProduct = false
                    self.viewModel.productToOffer = product
                    self.viewModel.showChatWithProduct = true
                }
            }
            .sheet(isPresented: $viewModel.showChatWithProduct) {
                ChatView(
                    viewModel: ChatViewModel(chatUser: viewModel.seller, product: viewModel.product, changeProduct: self.viewModel.productToOffer), callback: {
                        self.viewModel.showChatWithProduct = false
                    }
                )
            }
            .sheet(isPresented: $viewModel.showEditProduct) {
                CreateProductView(setTab: setTab, viewModel: CreateProductViewModel(product: viewModel.product))
            }
            .overlay(alignment: .bottom) {
                if !viewModel.product.isClosed {
                    if !viewModel.isOwnerLooking {
                        Button {
                            viewModel.showSelectProduct.toggle()
                        } label: {
                            Text("Предложить обмен")
                                .mainButtonStyle()
                        }
                        .padding()
                    } else {
                        Button {
                            viewModel.showEditProduct.toggle()
                        } label: {
                            Text("Редактировать объявление")
                                .mainButtonStyle()
                        }
                        .padding()
                    }
                }
            }
       // }
    }
}
