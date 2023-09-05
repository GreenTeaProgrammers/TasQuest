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
    
    @StateObject var viewModel = TaskViewModel()
    
    var body: some View {
        ZStack {
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
                                .frame(width: 5, height: (71.95) * (CGFloat(goal.tasks.filter { $0.isVisible }.count - 1)))// 71.95は微調整の結果
                        }
                        .padding(.leading, 9)  // 9は微調整の結果
                        
                        // 各タスクと円
                        VStack(alignment: .leading) {
                            ForEach(goal.tasks.indices, id: \.self) { index in
                                if goal.tasks[index].isVisible {  // isVisibleがtrueの場合だけ表示
                                    Button(action: {
                                        // ボタンが押されたときの処理
                                        print("Task \(goal.tasks[index].id) was clicked")
                                    }) {
                                        HStack {
                                            // 円形イメージ
                                            Image(systemName: "circle.fill")
                                                .resizable()
                                                .frame(width: 24, height: 24)
                                                .foregroundColor(.blue)
                                            
                                            VStack(alignment: .leading) {
                                                Text(goal.tasks[index].name)
                                                    .font(.body)
                                                    .foregroundColor(.black)
                                                
                                                Text(goal.tasks[index].dueDate)
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                            }
                                            
                                            Spacer() // <--- 追加されたSpacer
                                            
                                            // 体力バーのプログラム
                                            VStack {
                                                Capsule()
                                                    .fill(.gray.opacity(0.2))
                                                    .frame(width: 150, height: 8)
                                                    .overlay(alignment: .leading) {
                                                        Rectangle()
                                                            .fill(viewModel.fillColor)
                                                            .frame(width: 150 * viewModel.percentage)
                                                    }
                                                    .cornerRadius(4)

                                                Text("\(Int(goal.tasks[index].currentHealth))/\(Int(goal.tasks[index].maxHealth))")
                                                    .font(.footnote.bold())
                                                    .kerning(2)
                                                    .padding(.bottom, 24)
                                            }
                                        }
                                    }
                                    .frame(height: 64)  // 各HStack（Button）の高さを固定
                                    .background(Color.clear)  // 背景を透明にする
                                }
                            }
                        }

                    }
                }
            }
            .padding()
            HStack{
                Spacer()
                
                VStack{
                    Spacer()
                    
                    // タスクの追加ボタン（＋マーク）
                    Button(action: {
                        // タスク追加の処理
                    }) {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .foregroundColor(.blue)
                            .frame(width: 55, height: 55)
                            .overlay(
                                Image(systemName: "plus")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                            )
                    }
                    
                    
                    // ゲームビューボタン（ゲームコントローラーのイラスト）
                    Button(action: {
                        // ゲームビューの処理
                    }) {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .foregroundColor(.blue)
                            .frame(width: 55, height: 55)
                            .overlay(
                                Image(systemName: "gamecontroller")
                                    .resizable()
                                    .frame(width: 35, height: 20)
                                    .foregroundColor(.white)
                        )
                    }
                    
                    // ゴミ箱のボタン（ゴミ箱のアイコン）
                    Button(action: {
                        // ゴミ箱の処理
                    }) {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .foregroundColor(.blue)
                            .frame(width: 55, height: 55)
                            .overlay(
                                Image(systemName: "trash")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                                )
                    }
                }
                .padding(.bottom, 60)
                .padding(.trailing, 16)
            }
        }
    }
}
