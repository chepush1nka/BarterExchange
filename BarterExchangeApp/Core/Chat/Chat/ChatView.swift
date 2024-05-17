//
//  ChatView.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 06.05.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct ChatView: View {

    var tabBarVisibility: (() -> ())? = nil
    var callback: (() -> ())? = nil

    @ObservedObject var viewModel: ChatViewModel

    init(viewModel: ChatViewModel, tabBarVisibility: (() -> ())? = nil, callback: (() -> ())? = nil) {
        self.tabBarVisibility = tabBarVisibility
        self.callback = callback
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            customNavBar
            ZStack {
                messagesView
                Text(viewModel.errorMessage)
            }
        }
        .navigationTitle(viewModel.chatUser?.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            menu
        })
        .onAppear {
            guard let vis = tabBarVisibility else {
                return
            }
            vis()
        }
        .onDisappear {
            viewModel.firestoreListener?.remove()
            guard let call = callback else {
                return
            }
            call()
        }
    }

    static let emptyScrollToString = "Empty"

    private var customNavBar: some View {
        VStack(alignment: .center) {
            HStack(spacing: 16) {
                if let uid = FirebaseManager.shared.auth.currentUser?.uid,
                   viewModel.product?.userUid == uid {
                    if viewModel.offerProduct?.productImageUrls.count ?? -1 > 0 {
                        WebImage(url: URL(string: viewModel.offerProduct?.productImageUrls[0] ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 50, height: 50)
                        .background(Color(UIColor.systemGray5))
                        .clipShape(Circle())
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.offerProduct?.title ?? "")
                            .font(.system(size: 24, weight: .bold))

                        if let isClosed = viewModel.offerProduct?.isClosed {
                            Text("Статус: \(isClosed ? "Обмен совершен" : "Активен")")
                                .font(.system(size: 12))
                                .foregroundColor(Color(.gray))
                        }

                    }
                } else {
                    if viewModel.offerProduct?.productImageUrls.count ?? -1 > 0 {
                        WebImage(url: URL(string: viewModel.product?.productImageUrls[0] ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 50, height: 50)
                        .background(Color(UIColor.systemGray5))
                        .clipShape(Circle())
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.product?.title ?? "")
                            .font(.system(size: 24, weight: .bold))

                        if let isClosed = viewModel.product?.isClosed {
                            Text("Статус: \(isClosed ? "Обмен совершен" : "Активен")")
                                .font(.system(size: 12))
                                .foregroundColor(Color(.gray))
                        }

                    }
                }
                Spacer()
            }
        }
        .padding()
        .actionSheet(isPresented: $viewModel.shouldShowCloseProductOptions) {
            .init(title: Text("Завершение сделки"), message: Text("Вы уверены что хотите завершить обмен?"), buttons: [
                .destructive(Text("Завершить"), action: {
                    viewModel.closeProduct()
                }),
                .cancel()
            ])
        }
    }

    private var menu: some View {
            Menu {
                Button {
                } label: {
                    Label("Перейти в профиль", systemImage: "person.circle")
                }
                Button {
                } label: {
                    Label("Перейти к объявлению", systemImage: "newspaper.circle")
                }
                if let uid = FirebaseManager.shared.auth.currentUser?.uid,
                   viewModel.product?.userUid == uid,
                   !(viewModel.product?.isClosed ?? true),
                   !(viewModel.offerProduct?.isClosed ?? true) {
                    Button {
                        viewModel.shouldShowCloseProductOptions.toggle()
                    } label: {
                        Label("Завершить сделку", systemImage: "checkmark.seal")
                    }
                }
            } label: {
                Image(systemName: "ellipsis")
                    .rotationEffect(.degrees(90))
                    .foregroundStyle(.black)
            }
        }

    private var messagesView: some View {
        VStack {
            ScrollView {
                ScrollViewReader { scrollViewProxy in
                    VStack {
                        Spacer()
                        ForEach(viewModel.chatMessages) { message in
                            MessageView(message: message)
                        }

                        HStack{ Spacer() }
                            .id(Self.emptyScrollToString)
                    }
                    .onReceive(viewModel.$count) { _ in
                        withAnimation(.easeOut(duration: 0.5)) {
                            scrollViewProxy.scrollTo(Self.emptyScrollToString, anchor: .bottom)
                        }
                    }
                }
            }
            .background(Color(.init(white: 0.95, alpha: 1)))
            .safeAreaInset(edge: .bottom) {
                VStack {
                    Text(viewModel.status)
                        .foregroundStyle(.red)
                        .font(.callout)
                    chatBottomBar
                        .background(Color(.systemBackground).ignoresSafeArea())
                }
            }
        }
    }

    private var chatBottomBar: some View {
        HStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 24))
                .foregroundColor(Color(.darkGray))
            ZStack {
                DescriptionPlaceholder()
                TextEditor(text: $viewModel.chatText)
                    .opacity(viewModel.chatText.isEmpty ? 0.5 : 1)
                    .lineLimit(5)
            }
            .frame(height: 40)

            Button {
                viewModel.handleSendMessage()
            } label: {
                if !viewModel.chatText.isEmpty {
                    Image(systemName: "arrow.up")
                        .font(.system(size: 24))
                        .foregroundColor(.black)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color(red: 217/255, green: 247/255, blue: 23/255))
                        .clipShape(Circle())
                } else {
                    Image(systemName: "arrow.up")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

private struct DescriptionPlaceholder: View {
    var body: some View {
        HStack {
            Text("Сообщение")
                .foregroundColor(Color(.gray))
                .font(.system(size: 17))
                .padding(.leading, 5)
                .padding(.top, -4)
            Spacer()
        }
    }
}

#Preview {
    NavigationView {
        ChatView(viewModel: ChatViewModel(chatUser: User(uid: "db", name: "Pops", location: "Москва", phoneNumber: "popa@gmail.com", profileImageUrl:
                                        "https://firebasestorage.googleapis.com:443/v0/b/barter-exchange-app-b3873.appspot.com/o/FnhxA8J6tLfF13wQEUeTQRShYw93?alt=media&token=ce8ea166-3d22-4a48-ac2b-93da7767c7a5", averageRating: 0, ratingsCount: 0)), tabBarVisibility: {
            print("")
        })
    }
}
