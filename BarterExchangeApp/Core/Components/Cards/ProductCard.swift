//
//  ProductCard.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 31.01.2024.
//

import Foundation
import SwiftUI

struct ProductCard: View {
    let product: Product

    var body: some View {
        VStack(spacing: 8) {
            ProductAsyncImageCarouselView(imagesURLs: product.productImageUrls)
                .frame(width: 177, height: 193)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(product.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                        .lineLimit(2)
                    Text(product.location)
                        .foregroundStyle(.gray)
                        .font(.footnote)
                }
                Spacer()
            }
        }.frame(width: 177, height: 260)
    }
}
