//
//  CreateTaskView.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/10.
//

import SwiftUI

struct CreateTaskHalfModalView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var appData: AppData  // AppDataをBindingで受け取る

    @State private var selectedDate = Date()
    
    @State var name: String = ""
    @State var description: String = ""
    @State var dueDate: String = ""
    @State var maxHealth: Float = 0.0
    @State var currentHealth: Float = 0.0
    @State var selectedTags: [Tag] = []  // 選択されたタグを保存するための変数

    @ObservedObject var keyboard = KeyboardResponder()

    var body: some View {
        ScrollView {
            VStack {
                // モーダルのタイトルと閉じるボタン
                HStack {
                    Text("New Task")
                        .font(.title)
                    Spacer()
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .padding()
                
                // タスク名
                TextField("Task Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                // 説明
                TextField("Description", text: $description)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                // 期限
                DatePicker("Due Date", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                    .padding()
                
                // 最大健康値
                HStack {
                    Text("Max Health:")
                    Slider(value: $maxHealth, in: 0...3000)
                    Text("\(Int(maxHealth))")
                }
                .padding()
                
                // 現在の健康値
                HStack {
                    Text("Current Health:")
                    Slider(value: $currentHealth, in: 0...maxHealth)
                    Text("\(Int(currentHealth))")
                }
                .padding()
                
                // タグ（簡易的な例）
                Text("Tags:")
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(appData.tags, id: \.id) { tag in
                            Button(action: {
                                if selectedTags.contains(tag) {
                                    selectedTags.removeAll { $0.id == tag.id }
                                } else {
                                    selectedTags.append(tag)
                                }
                            }) {
                                Text(tag.name)
                                    .padding(.horizontal)
                                    .background(selectedTags.contains(tag) ? Color.blue : Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                
                // 選択されたタグ
                Text("Selected Tags:")
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(selectedTags, id: \.id) { tag in
                            Text(tag.name)
                                .padding(.horizontal)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                }
                

                
                Button("Save Task") {
                    // 選択された日付と時間を文字列に変換
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd/HH:mm:ss"
                    dueDate = formatter.string(from: selectedDate)
                    
                    // タスクの保存処理をここに書く
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                Spacer()
                    .frame(height: UIScreen.main.bounds.height / 2 - keyboard.currentHeight)  // ハーフモーダルの高さを設定
            }
            .padding(.bottom, keyboard.currentHeight)  // キーボードの高さに合わせてパディングを追加
        }
        .onAppear {
            self.keyboard.startObserve()  // キーボードの表示・非表示を監視
        }
        .onDisappear {
            self.keyboard.stopObserve()  // キーボードの監視を停止
        }
    }
}
