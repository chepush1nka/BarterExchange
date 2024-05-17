//
//  SwiftUIView.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 23.04.2024.
//

import SwiftUI

struct FiltersView: View {

    let callback: (Filter) -> ()

    @ObservedObject var viewModel: FiltersViewModel

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Местоположение")
                        .font(.headline)
                        .padding(.vertical)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            if let city = viewModel.filter.selectedCity {
                                Button {
                                    viewModel.filter.selectedCity = nil
                                    viewModel.showSelectCity.toggle()
                                } label: {
                                    Text(city)
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .background(Color(red: 217/255, green: 247/255, blue: 23/255))
                                .foregroundStyle(.black)
                                .cornerRadius(15)
                            } else {
                                Button {
                                    viewModel.showSelectCity.toggle()
                                } label: {
                                    Text("Выберите гороод")
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .background(Color.gray.opacity(0.2))
                                .foregroundStyle(.black)
                                .cornerRadius(15)
                            }
                        }
                    }

                    Divider()

                    Text("Состояние товара")
                        .font(.headline)
                        .padding(.vertical)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(Condition.allCasesString(), id: \.self) { manufacturer in
                                if viewModel.filter.selectedCondition == manufacturer {
                                    Button {
                                        viewModel.filter.selectedCondition = nil
                                    } label: {
                                        Text(manufacturer)
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 5)
                                    .foregroundStyle(.black)
                                    .background(Color(red: 217/255, green: 247/255, blue: 23/255))
                                    .cornerRadius(15)
                                } else {
                                    Button {
                                        viewModel.filter.selectedCondition = manufacturer
                                    } label: {
                                        Text(manufacturer)
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 5)
                                    .foregroundStyle(.black)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(15)
                                }
                            }
                        }
                    }

                    Divider()

                    Text("Категория")
                        .font(.headline)
                        .padding(.vertical)
                    HStack {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(Category.getAllCasesString(), id: \.self) { manufacturer in
                                    if viewModel.filter.selectedCategory == manufacturer {
                                        Button {
                                            viewModel.filter.selectedCategory = nil
                                            viewModel.filter.selectedSubcategory = nil
                                        } label: {
                                            Text(manufacturer)
                                        }
                                        .padding(.horizontal)
                                        .padding(.vertical, 5)
                                        .foregroundStyle(.black)
                                        .background(Color(red: 217/255, green: 247/255, blue: 23/255))
                                        .cornerRadius(15)
                                    } else {
                                        Button {
                                            viewModel.filter.selectedCategory = manufacturer
                                            viewModel.filter.selectedSubcategory = nil
                                        } label: {
                                            Text(manufacturer)
                                        }
                                        .padding(.horizontal)
                                        .padding(.vertical, 5)
                                        .foregroundStyle(.black)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(15)
                                    }
                                }
                            }
                        }
                    }

                    if viewModel.filter.selectedCategory != "" {
                        Text("Тип")
                            .font(.headline)
                            .padding(.vertical)
                        HStack {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(Category.mapToCategory(from: viewModel.filter.selectedCategory ?? "", with: "").toStringSubtypes(), id: \.self) { manufacturer in
                                        if viewModel.filter.selectedSubcategory == manufacturer {
                                            Button {
                                                viewModel.filter.selectedSubcategory = nil
                                            } label: {
                                                Text(manufacturer)
                                            }
                                            .padding(.horizontal)
                                            .padding(.vertical, 5)
                                            .foregroundStyle(.black)
                                            .background(Color(red: 217/255, green: 247/255, blue: 23/255))
                                            .cornerRadius(15)
                                        } else {
                                            Button {
                                                viewModel.filter.selectedSubcategory = manufacturer
                                            } label: {
                                                Text(manufacturer)
                                            }
                                            .padding(.horizontal)
                                            .padding(.vertical, 5)
                                            .foregroundStyle(.black)
                                            .background(Color.gray.opacity(0.2))
                                            .cornerRadius(15)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .overlay(alignment: .bottom)  {
                Button {
                    presentationMode.wrappedValue.dismiss()
                    self.callback(viewModel.filter)
                } label: {
                    Text("Показать товары")
                        .mainButtonStyle()
                        .padding()
                }
            }
            .navigationTitle("Фильтры")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $viewModel.showSelectCity) {
                SelectCityView { city in
                    self.viewModel.filter.selectedCity = city
                    self.viewModel.showSelectCity = false
                }
            }
        }
        .onDisappear {
            self.callback(viewModel.filter)
        }
    }
}

#Preview {
    FiltersView(callback: { filter in
        print("filter")
    }, viewModel: FiltersViewModel(filter: nil))
}
