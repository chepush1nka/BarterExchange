//
//  RootChatView.swift
//  BarterExchangeApp
//
//  Created by Pavel Vyaltsev on 01.05.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct RootChatView: View {
    @State var shouldShowLogOutOptions = false

    @State var vis: Visibility = .visible

    @ObservedObject private var viewModel = RootChatViewModel()

    var body: some View {
        NavigationView {
            VStack {
                customNavBar
                messagesView
            }
            .navigationBarHidden(true)
            .toolbar(vis, for: .tabBar)
            .onAppear {
                vis = .visible
                viewModel.fetchRecentMessages()
            }
            .onDisappear {
                viewModel.firestoreListener?.remove()
            }
        }
    }

    private var customNavBar: some View {
        VStack {
//            HStack(spacing: 16) {
//
//                AsyncImage(url: URL(string: viewModel.chatUser?.profileImageUrl ?? "")) { image in
//                    image
//                        .resizable()
//                        .scaledToFill()
//                        .clipShape(Circle())
//                } placeholder: {
//                    ProgressView()
//                }
//                .frame(width: 50, height: 50)
//                .background(Color(UIColor.systemGray5))
//                .clipShape(Circle())
//
//
//                VStack(alignment: .leading, spacing: 4) {
//                    Text("Сообщения")
//                        .font(.system(size: 24, weight: .bold))
//                }
//            }
//            .padding()
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding(.leading, 8)

                TextField("Поиск", text: $viewModel.searchText)
                    .foregroundColor(.primary)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 0)

                if !viewModel.searchText.isEmpty {
                    Button(action: {
                        viewModel.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .padding(.trailing, 8)
                    }
                }
            }
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding()
            .padding(.top, 20)
        }
    }

    private var messagesView: some View {
        ScrollView {
            ForEach(viewModel.filteredMessages) { recentMessage in
                VStack {
                    NavigationLink {
                        ChatView(viewModel: ChatViewModel(chatUser: recentMessage.sender),
                                 tabBarVisibility: {
                            self.vis = .hidden
                        })
                    } label: {
                        HStack(spacing: 16) {
                            WebImage(url: URL(string: recentMessage.sender?.profileImageUrl ?? "")) { image in
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

                            VStack(alignment: .leading, spacing: 8) {
                                Text(recentMessage.sender?.name ?? "Пользователь")
                                    .font(.system(size: 16, weight: .bold))
                                Text(recentMessage.text)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(.darkGray))
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(2)
                            }
                            Spacer()

                            //                            Text(recentMessage.timeAgo)
                            //                                .font(.system(size: 14, weight: .semibold))
                        }
                    }
                    Divider()
                        .padding(.vertical, 8)
                }.padding(.horizontal)

            }.padding(.bottom, 50)
        }
    }
}

#Preview {
    RootChatView()
}
