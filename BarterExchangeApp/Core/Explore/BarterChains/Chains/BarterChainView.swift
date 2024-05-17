//
//  BarterChainView.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 12.05.2024.
//

import SwiftUI

struct BarterChainView: View {

    var cancel: () -> ()
    var column = [GridItem(.adaptive(minimum: 130), spacing: 10)]

    @ObservedObject var viewModel: BarterChainsViewModel

    @State var isTargeted = false
    @State var isFavoritesTargeted = false

    init(viewModel: BarterChainsViewModel, cancel: @escaping () -> Void) {
        self.viewModel = viewModel
        self.cancel = cancel
    }

    var body: some View {
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
                            .foregroundStyle(.black)
                    }
                }

                Spacer()
            }
            .padding(.horizontal)
            ScrollView {
                VStack {
                    HStack {
                        Text("Цепочка:")
                            .font(.title)
                            .fontWeight(.medium)
                            .padding(.bottom, 2)
                        Spacer()
                    }
                    HStack {
                        Text("Выберите товар для того чтобы проследить цепочку обмена")
                            .font(.subheadline)
                            .foregroundStyle(Color(.systemGray))
                            .padding(.bottom)
                        Spacer()
                    }


                    RoundedRectangle(cornerRadius: 20)
                        .fill(isTargeted ?
                              Color(red: 217/255, green: 247/255, blue: 23/255).opacity(0.7)
                              : Color(.systemGray6))
                        .aspectRatio(1, contentMode: .fit)
                        .overlay(
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(viewModel.products, id: \.self) { product in
                                        if product.productUid == viewModel.selectedProduct.productUid {
                                            ProductCard(product: product)
                                                .padding(.horizontal)
                                        } else {
                                            ProductCard(product: product)
                                                .padding(.horizontal)
                                                .draggable(product)
                                        }
                                        VStack {
                                            Spacer()
                                            Image(systemName: "arrow.right")
                                                .padding()
                                            Spacer()
                                        }
                                    }
                                }
                            }
                                .dropDestination(for: Product.self) { droppedProducts, location in
                                    for product in droppedProducts {
                                        self.viewModel.favorites.removeAll { $0 == product }
                                        let insertionIndex = self.calculateInsertionIndex(location: location)
                                        if viewModel.products.contains(product) {
                                            viewModel.products.removeAll { $0 == product }
                                        }
                                        self.viewModel.products.insert(product, at: insertionIndex)
                                    }
                                    return true
                                } isTargeted: { isTargeted in
                                    self.isTargeted = isTargeted
                                }

                        )
                    if viewModel.products.count > 1 {
                        Button {
                            viewModel.saveBarterChain()
                        } label: {
                            Text("Сохранить")
                                .mainButtonStyle()
                        }
                    }
                    HStack {
                        Text("Предложения:")
                            .font(.title)
                            .fontWeight(.medium)
                            .padding(.bottom, 2)
                            .padding(.top)
                        Spacer()
                    }
                    LazyVGrid(columns: column, spacing: 20) {
                        ForEach(viewModel.favorites, id: \.productUid) { product in
                            ProductCard(product: product)
                                .draggable(product)
                        }
                    }
                    .dropDestination(for: Product.self) { droppedProducts, location in
                        for product in droppedProducts {
                            self.viewModel.products.removeAll { $0 == product }
                            if viewModel.favorites.contains(product) {
                                continue
                            }
                            self.viewModel.favorites.insert(product, at: 0)
                        }
                        return true
                    } isTargeted: { isTargeted in
                        self.isFavoritesTargeted = isTargeted
                    }

                }
                .padding()
                Spacer()
            }
        }
    }

    private func calculateInsertionIndex(location: CGPoint) -> Int {
        let cardWidth: CGFloat = 177
        let spacing: CGFloat = 16
        let totalWidth = cardWidth + spacing
        let index = Int((location.x + spacing / 2) / totalWidth)
        let ans = min(index, viewModel.products.count)
        return ans == 0 ? 1 : ans
    }

}

#Preview {
    BarterChainView(viewModel: BarterChainsViewModel(product: Product(data: [:]), getFavorites: {
        return [Product(data: [:])]
    })) {
        print("")
    }
}
