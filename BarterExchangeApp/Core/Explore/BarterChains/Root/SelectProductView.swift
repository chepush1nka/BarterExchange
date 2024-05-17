//
//  BarterChainsView.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 12.05.2024.
//

import SwiftUI

struct SelectProductView: View {

    @ObservedObject var viewModel: SelectProductViewModel
    var column = [GridItem(.adaptive(minimum: 130), spacing: 10)]

    let mode: SelectProductMode
    var callback: ((Product) -> ())? = nil

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Text("Ваши товары:")
                        .font(.title)
                        .fontWeight(.medium)
                        .padding(.bottom, 2)
                    Spacer()
                }
                Text("Выберите товар для \(mode == .chains ? "того чтобы построить цепочку обмена": "того чтобы предложить обмен")")
                    .font(.subheadline)
                    .foregroundStyle(Color(.systemGray))
                    .padding(.bottom)
                LazyVGrid(columns: column, spacing: 10) {
                    ForEach(viewModel.products, id: \.productUid) { product in
                        Button {
                            viewModel.selectedProduct = product
                            if mode == .chains {
                                viewModel.shoudOpenChains.toggle()
                            } else {
                                guard let exCallback = callback else {
                                    return
                                }
                                exCallback(product)
                            }
                        } label: {
                            ProductCard(product: product)
                        }
                    }
                }
            }
            .padding()
        }
        .fullScreenCover(isPresented: $viewModel.shoudOpenChains, content: {
            if let product = viewModel.selectedProduct {
                BarterChainView(viewModel:
                                    BarterChainsViewModel(product: product, getFavorites: viewModel.getFavorites),
                                cancel: {
                    viewModel.shoudOpenChains = false
                })
            }
        })
    }
}

//#Preview {
//    BarterChainsView()
//}
