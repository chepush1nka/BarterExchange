//
//  CreateProductView.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 07.05.2024.
//

import SwiftUI
import PhotosUI

struct CreateProductView: View {

    let setTab: (() -> ())?

    @ObservedObject var viewModel: CreateProductViewModel = CreateProductViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                PhotosPicker(selection: $viewModel.photosPickerItems, maxSelectionCount: 5, selectionBehavior: .ordered) {
                    if viewModel.images.count == 0 {
                        if let urls = viewModel.existingImagesUrl {
                            ProductAsyncImageCarouselView(imagesURLs: urls)
                                .frame(height: 394)
                                .cornerRadius(20)
                                .padding(.top, 40)
                        } else {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(.systemGray5))
                                .aspectRatio(1, contentMode: .fit)
                                .overlay(
                                    Image(systemName: "plus.circle")
                                        .font(.system(size: 60))
                                        .foregroundColor(Color(.systemGray3))
                                )
                                .padding(.bottom)
                        }
                    } else {
                        ProductImageCarouselView(images: viewModel.images)
                            .frame(height: 394)
                            .cornerRadius(20)
                            .padding(.top, 40)
                    }
                }

                Text("Название")
                    .font(.callout)
                    .foregroundStyle(Color(.systemGray))
                TextField("", text: $viewModel.title)
                    .keyboardType(.emailAddress)
                Divider()

                Text("Описание")
                    .font(.callout)
                    .foregroundStyle(Color(.systemGray))
                TextField("", text: $viewModel.description)
                    .keyboardType(.emailAddress)
                Divider()

                Text("Вид товара")
                    .font(.callout)
                    .foregroundStyle(Color(.systemGray))
                HStack {
                    Picker("Вид товара", selection: $viewModel.selectedProductType) {
                        ForEach(0..<viewModel.productTypes.count) { index in
                            Text(viewModel.productTypes[index]).tag(index)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                .fixedSize(horizontal: true, vertical: false)
                .padding(.horizontal, -10)

                if !viewModel.productSubtypes.isEmpty {
                    Text("Подвид товара")
                        .font(.callout)
                        .foregroundStyle(Color(.systemGray))
                    HStack {
                        Picker("Вид товара", selection: $viewModel.selectedProductSubtype) {
                            ForEach(0..<viewModel.productSubtypes.count) { index in
                                Text(viewModel.productSubtypes[index]).tag(index)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    .fixedSize(horizontal: true, vertical: false)
                    .padding(.horizontal, -10)
                }

                Text("Состояние товара")
                    .font(.callout)
                    .foregroundStyle(Color(.systemGray))
                HStack {
                    Picker("Состояние товара", selection: $viewModel.selectedCondition) {
                        ForEach(0..<viewModel.conditions.count) { index in
                            Text(viewModel.conditions[index]).tag(index)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                .fixedSize(horizontal: true, vertical: false)
                .padding(.horizontal, -10)

                Text("Локация")
                    .font(.callout)
                    .foregroundStyle(Color(.systemGray))
                Button {
                    viewModel.showSearchCity.toggle()
                } label: {
                    Text(viewModel.location)
                }


                Divider()

                Button {
                    viewModel.publishProduct()
                    if let tab = setTab {
                        tab()
                    }
                } label: {
                    Text("Опубликовать")
                        .mainButtonStyle()
                }
                .padding(.top)

                if (viewModel.existingProductUid != nil) {
                    Button {
                        viewModel.deleteProduct()
                    } label: {
                        Text("Удалить объявление")
                            .frame(minWidth: 0,
                                   maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color(.systemGray5))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .foregroundStyle(.black)
                    }
                    .padding(.top, 5)
                }
            }
            .padding(.horizontal)
        }
        .sheet(isPresented: $viewModel.showSearchCity) {
            SelectCityView { city in
                self.viewModel.location = city
                self.viewModel.showSearchCity = false
            }
        }
    }
}

#Preview {
    CreateProductView(setTab: {
        print("setTab")
    })
}
