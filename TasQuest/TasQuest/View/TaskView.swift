//
//  ContentView.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/04.
//

import SwiftUI

struct TaskView: View {
    var goal: Goal
    
    var body: some View {
        VStack {
            // Goal情報表示エリア
            Text(goal.name)
                .font(.title)
                .padding(.top)
            
            Text(goal.dueDate)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            // Taskリスト表示エリア
            ScrollView {
                // 縦の線を描画
                VStack(alignment: .leading) {
                    ForEach(goal.tasks.indices, id: \.self) { index in
                        HStack {
                            // 円形イメージ (ここではシステムイメージを使用)
                            Image(systemName: "circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.blue)
                            
                            // 線を描画
                            if index < goal.tasks.count - 1 {
                                VStack {
                                    Divider()
                                        .background(Color.blue)
                                }
                                .frame(height: 24)
                            }
                            
                            // タスク情報
                            VStack(alignment: .leading) {
                                Text(goal.tasks[index].name)
                                    .font(.body)
                                
                                Text(goal.tasks[index].dueDate)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.bottom)
                    }
                }
            }
        }
        .padding()
    }
}
