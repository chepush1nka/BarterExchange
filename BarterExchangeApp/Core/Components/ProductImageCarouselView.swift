//
//  ProductImageCarouselView.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 07.04.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProductImageCarouselView: View {
    let images: [UIImage]

    var body: some View {
        TabView {
            ForEach(images, id: \.self) { image in
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
        .tabViewStyle(.page)
    }
}

struct ProductAsyncImageCarouselView: View {
    let imagesURLs: [String]

    var body: some View {
        TabView {
            ForEach(Array(zip(imagesURLs.indices, imagesURLs)), id: \.0) { index, imageURL in
                WebImage(url: URL(string: imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
            }
        }
        .tabViewStyle(.page)
    }
}
