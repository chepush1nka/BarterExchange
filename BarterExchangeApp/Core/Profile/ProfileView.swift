//
//  Profile.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 17.04.2024.
//

import SwiftUI
import FirebaseFirestore
import SDWebImageSwiftUI

struct ProfileView: View {
    @State var shouldShowLogOutOptions = false
    @Namespace var animation

    @ObservedObject private var viewModel: ProfileViewModel

    private var column = [GridItem(.adaptive(minimum: 160), spacing: 20)]

    init(didLogOut: @escaping () -> Void, getFavorites: @escaping () -> [Product]) {
        viewModel = ProfileViewModel(didLogOut: didLogOut, getFavorites: getFavorites)
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
                        viewModel.shoulShowEditProfile.toggle()
                    } label: {
                        Text("Редактировать профиль")
                            .mainButtonStyle()
                    }
                    .padding(.horizontal)

                    profileFilterBar
                        .padding(.horizontal)
                    if viewModel.selectedFilter == .sells {
                        LazyVGrid(columns: column, spacing: 20) {
                            ForEach(viewModel.products, id: \.productUid) { product in
                                NavigationLink(value: product) {
                                    ProductCard(product: product)
                                }
                            }
                        }
                        .padding()
                    } else if viewModel.selectedFilter == .wants {
                        LazyVGrid(columns: column, spacing: 20) {
                            ForEach(viewModel.favorites, id: \.productUid) { product in
                                NavigationLink(value: product) {
                                    ProductCard(product: product)
                                }
                            }
                        }
                        .padding()
                    } else {
                        LazyVGrid(columns: column, spacing: 20) {
                            ForEach(viewModel.closedProducts, id: \.productUid) { product in
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        shouldShowLogOutOptions.toggle()
                    }) {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.degrees(90))
                            .foregroundStyle(.black)
                    }
                }
            }
            .actionSheet(isPresented: $shouldShowLogOutOptions) {
                .init(title: Text("Настройки"), message: Text("Что вы хотите сделать?"), buttons: [
                    .destructive(Text("Выйти"), action: {
                        viewModel.handleSignOut()
                    }),
                        .cancel()
                ])
            }
            .sheet(isPresented: $viewModel.shoulShowEditProfile) {
                ProfileInfoView(didCompleteLogIn: {
                    viewModel.fetchCurrentUser()
                }, user: viewModel.user)
            }
            .refreshable {
                viewModel.fetchProducts()
            }
        }
        .onAppear {
            viewModel.fetchFavorites()
        }
    }

    var profileFilterBar: some View {
        HStack {
            ForEach(ProfileFilterViewModel.allCases, id: \.rawValue) { item in
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

#Preview {
    ProfileView(didLogOut: {
        print("didLogOut")
    }, getFavorites: {
        return [Product(productUid: "", userUid: "", title: "", description: "", productImageUrls: [""], type: "", subtype: "", condition: "", timestamp: Timestamp(), location: "", isClosed: false)]
    })
}
