//
//  ProfileInfoView.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 30.04.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileInfoView: View {

    var didCompleteLogIn: () -> ()

    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var viewModel: ProfileInfoViewModel

    init(didCompleteLogIn: @escaping () -> Void, user: User? = nil) {
        self.didCompleteLogIn = didCompleteLogIn
        self.viewModel = ProfileInfoViewModel(didCompleteLogIn: didCompleteLogIn, user: user)
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Button {
                        viewModel.handleImageAction()
                    } label: {
                        if let image = viewModel.image {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 125, height: 125)
                                .clipShape(Circle())
                        } else if let user = viewModel.existingUser {
                            WebImage(url: URL(string: user.profileImageUrl)) { image in
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
                        } else {
                            Image(systemName: "person.fill")
                                .font(.system(size: 65))
                                .padding()
                        }
                    }
                    Spacer()
                }
                .padding(.bottom)
                Text(viewModel.statusLabel)
                    .font(.callout)
                    .foregroundStyle(.red)

                Text("Имя")
                    .foregroundStyle(Color.gray.opacity(0.5))
                TextField("", text: $viewModel.name)
                    .autocorrectionDisabled()
                Divider()
                    .padding(.bottom)

                Text("Номер телефона")
                    .foregroundStyle(Color.gray.opacity(0.5))
                TextField("", text: $viewModel.number)
                    .autocorrectionDisabled()
                    .keyboardType(.numberPad)
                Divider()
                    .padding(.bottom)

                Text("Ваш город")
                    .foregroundStyle(Color.gray.opacity(0.5))
                Button {
                    viewModel.showSearchCity.toggle()
                } label: {
                    Text(viewModel.town)
                }
                Divider()

                Spacer()

                Button {
                    let result = viewModel.saveUserInfo()
                    if result {
                        presentationMode.wrappedValue.dismiss()
                    }
                } label: {
                    Text("Продолжить")
                        .mainButtonStyle()
                }
            }
            .padding()
            .fullScreenCover(isPresented: $viewModel.shouldShowImagePicker) {
                ImagePicker(image: $viewModel.image)
            }
            .sheet(isPresented: $viewModel.showSearchCity) {
                SelectCityView { city in
                    self.viewModel.town = city
                    self.viewModel.showSearchCity = false
                }
            }
        }
    }
}

#Preview {
    ProfileInfoView(didCompleteLogIn: {
        print("didCompleteLogIn")
    })
}
