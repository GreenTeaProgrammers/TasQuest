//
//  ContentView.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/04.
//

import SwiftUI


struct TaskView: View {
    var goal: Goal
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                Text(goal.name)
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .center)  // 中央に配置
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.blue)
                }
                .padding(.leading)  // 左側に少し余白を追加
            }
            .padding(.top)
            
            Text(goal.dueDate)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            // Taskリスト表示エリア
            ScrollView {
                ZStack(alignment: .leading) {
                    // 縦の線を描画
                    VStack {
                        Rectangle()
                            .fill(Color.black)
                            .frame(width: 5, height: (71.95) * (CGFloat(goal.tasks.count - 1)))// 64は各HStackの高さ
                    }
                    .padding(.leading, 9)  // 9は微調整の結果

                    // 各タスクと円
                    VStack(alignment: .leading) {
                        ForEach(goal.tasks.indices, id: \.self) { index in
                            HStack {
                                // 円形イメージ
                                Image(systemName: "circle.fill")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.blue)

                                VStack(alignment: .leading) {
                                    Text(goal.tasks[index].name)
                                        .font(.body)
                                    
                                    Text(goal.tasks[index].dueDate)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                            }
                            .frame(height: 64)  // 各HStackの高さを固定
                        }
                    }
                }
            }
        }
        .padding()
    }
}
