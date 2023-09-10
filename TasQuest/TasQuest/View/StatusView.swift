//
//  StatusView.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/06.
//


import SwiftUI

struct GoalRow: View {
    @ObservedObject var viewModel: StatusViewModel

    var goal: Goal

    var body: some View {
        NavigationLink(destination: TaskView(goal: goal)) { // <-- NavigationLinkでラッピング
            HStack {
                Text(goal.name)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .bold()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(goal.dueDate)
                            .foregroundColor(.gray)
                        HStack {
                            ForEach(goal.tags.prefix(3).indices, id: \.self) { tagIndex in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(
                                            Color(
                                                red: Double(goal.tags[tagIndex].color[0]),
                                                green: Double(goal.tags[tagIndex].color[1]),
                                                blue: Double(goal.tags[tagIndex].color[2])
                                            ).opacity(0.2)
                                        )
                                    let truncatedTag = String(goal.tags[tagIndex].name.prefix(8))
                                    let displayTag = goal.tags[tagIndex].name.count > 8 ? "\(truncatedTag)..." : truncatedTag
                                    Text(displayTag)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .padding(.horizontal, 4)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                                .fixedSize()
                                .padding(.vertical, 2)
                            }
                        }
                    }
                    Spacer()
                }
                
                Spacer()
                
                Button(action: {
                    viewModel.toggleStar(forGoalWithID: goal.id)
                }) {
                    Image(systemName: goal.isStarred ? "star.fill" : "star")
                        .foregroundColor(goal.isStarred ? .yellow : .gray)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
        .overlay(
            NavigationLink("", destination: Text("Status View"))
                .opacity(0)
        )
        .padding(.bottom, 8)
    }
}


struct StatusView: View {
    @State private var showSignInView: Bool = false
    @State private var showSettingView: Bool = false

    @StateObject private var viewModel = StatusViewModel()
    
    var body: some View {
        NavigationStack{
            VStack {
                // ウェルカムメッセージと設定ボタン
                HStack {
                    Text("ようこそ \(viewModel.user.username)")
                        .font(.headline)
                    Spacer()
                    
                    Button(action: {
                        showSettingView = true
                    }) {
                        Image(systemName: "gear")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }.sheet(isPresented: $showSettingView) {
                        SettingView(showSignInView: $showSignInView)
                    }
                }
                .padding()
                .onAppear(){
                    viewModel.fetchAppData()
                }
                
                // ステータスとその目標を表示
                ScrollView {
                    ForEach(viewModel.user.statuses.indices, id: \.self) { index in
                        let status = viewModel.user.statuses[index]
                        
                        VStack {
                            Text(status.name)
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding(.top)
                            
                            if status.goals.isEmpty {
                                // ゴールがない場合の表示
                                HStack {
                                    Spacer()
                                    Text("ゴールがありません")
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                            }
                            else {
                                ForEach(status.goals, id: \.id) { goal in
                                    GoalRow(viewModel: viewModel, goal: goal)
                                        .background(
                                            NavigationLink("", destination: TaskView(goal: goal))
                                                .opacity(0)
                                        )
                                }
                            }
                             // 残りのスペースを埋める
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(viewModel.backgroundColor(for: index))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                        .padding(.bottom, 8)
                    }
                }
            }
            .fullScreenCover(isPresented: $showSignInView) {
                WelcomeView()
            }
            .onAppear() {
                viewModel.fetchAppData() // これだけでOK
                let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
                self.showSignInView = authUser == nil
            }
            Spacer()
        }
    }
}
