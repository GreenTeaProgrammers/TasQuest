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
        HStack {
            VStack(alignment: .leading) {
                Text(goal.name)
                Text(goal.dueDate)
            }
            
            Spacer()
            
            Button(action: {
                viewModel.toggleStar(forGoalWithID: goal.id)
            }) {
                Image(systemName: goal.isStarred ? "star.fill" : "star")
                    .foregroundColor(goal.isStarred ? .yellow : .gray)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.white) // 背景を白に設定
        .cornerRadius(10) // 角を丸くする
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2) // 影をつける
        .overlay(
            NavigationLink("", destination: Text("Status View")) // ここで遷移先を設定します
                .opacity(0) // NavigationLink を透明にする
        )
        .padding(.bottom, 8)
    }
}

struct StatusView: View {
    @State private var showSignInView: Bool = false
    @State private var showSettingView: Bool = false

    @StateObject private var viewModel = StatusViewModel()
    
    var body: some View {
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
            
            // ステータスとその目標を表示
            ScrollView {
                ForEach(viewModel.user.statuses.indices, id: \.self) { index in
                    let status = viewModel.user.statuses[index]
                    
                    VStack {
                        Text(status.name)
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(.top)
                        
                        ForEach(status.goals, id: \.id) { goal in
                            GoalRow(viewModel: viewModel, goal: goal)
                        }
                    }
                    .padding()
                    .background(viewModel.backgroundColor(for: index))
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(lineWidth: 1)
                            .foregroundColor(.gray)
                    )
                    .padding(.bottom)
                }
            }
        }
        .fullScreenCover(isPresented: $showSignInView) {
            AuthenticationView(showSignInView: $showSignInView)
        }
        .onAppear() {
            viewModel.user = viewModel.setDummyData()
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
        }
        Spacer()
    }
}