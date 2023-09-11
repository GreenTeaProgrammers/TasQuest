//
//  CreateTaskView.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/10.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct CreateTaskHalfModalView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var appData: AppData  // AppDataをBindingで受け取る
    @Binding var status: Status
    @Binding var goal: Goal

    @State private var selectedDate = Date()
    @State var name: String = ""
    @State var description: String = ""
    @State var dueDate: String = ""
    @State var maxHealth: Float = 0.0
    @State var currentHealth: Float = 0.0
    @State var selectedTags: [Tag] = []
    @ObservedObject var keyboard = KeyboardResponder()

    var body: some View {
        VStack {
            modalHeader
            ScrollView {
                VStack {
                    inputFields
                    Divider()
                    healthSliders
                    Divider()
                    tagSelection
                }
                .padding(.bottom, keyboard.currentHeight)
            }
            saveButton
        }
        .onAppear { self.keyboard.startObserve() }
        .onDisappear { self.keyboard.stopObserve() }
    }
}

// MARK: - Subviews
extension CreateTaskHalfModalView {
    var modalHeader: some View {
        HStack {
            Text("新しいタスクの作成")
                .font(.title)
                .bold()
            Spacer()
        }
        .padding()
    }

    var inputFields: some View {
        Group {
            TextField("タスクの名前", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("タスクの説明", text: $description)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            HStack {
                Spacer()
                Image(systemName: "calendar")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.blue)
                DatePicker("", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
            }
            .padding()
        }
    }


    var healthSliders: some View {
        Group {
            HStack {
                Image(systemName: "heart.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.red)
                Text("最大")
                HealthSlider(label: "", value: $maxHealth, range: 0...3000)
            }
            .padding()
            //.help("敵の最大体力を設定します。")
            
            HStack {
                Image(systemName: "heart.slash.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.red)
                Text("現在")
                HealthSlider(label: "", value: $currentHealth, range: 0...maxHealth)
            }
            .padding()
            //.help("敵の現在体力を設定します。")
        }
    }
    
    var tagSelection: some View {
        TagSelectorView(tags: appData.tags, selectedTags: $selectedTags)
    }

    var saveButton: some View {
        Button(action: saveTask) {
            HStack {
                Image(systemName: "checkmark")
                Text("作成")
            }
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
    }
    
    func saveTask() {
        if currentHealth > maxHealth {
            currentHealth = maxHealth
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd/HH:mm:ss"
        
        let dueDateStr = formatter.string(from: selectedDate)
        let nowDateStr = formatter.string(from: Date())  // 現在の日時
        
        let newTask = TasQuestTask(
            id: "", // Firestore が生成する ID
            name: name,
            description: description,
            dueDate: dueDateStr,
            maxHealth: Float(maxHealth),
            currentHealth: Float(currentHealth),
            tags: selectedTags,
            isVisible: true,
            createdAt: nowDateStr,
            updatedAt: nowDateStr
        )
        
        // StatusとGoalの参照を取得
        if let statusIndex = appData.statuses.firstIndex(where: { $0.id == status.id }),
           let goalIndex = appData.statuses[statusIndex].goals.firstIndex(where: { $0.id == goal.id }) {
            
            // 新しいタスクを追加
            appData.statuses[statusIndex].goals[goalIndex].tasks.append(newTask)
            

            print(appData)
            
            FirestoreManager.shared.saveAppData(appData: appData) { error in
                if let error = error {
                    print("Failed to save data: \(error)")
                } else {
                    print("Data saved successfully.")
                    
                    // データが保存された後にデータを再取得
                    FirestoreManager.shared.fetchAppData { fetchedAppData in
                        if let fetchedAppData = fetchedAppData {
                            self.appData = fetchedAppData  // データを更新
                        } else {
                            // エラー処理
                        }
                    }
                }
            }
            // モーダルを閉じる
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct HealthSlider: View {
    var label: String
    @Binding var value: Float
    var range: ClosedRange<Float>

    var body: some View {
        HStack {
            Text(label)
            Slider(value: $value, in: range)
            Text("\(Int(value))")
        }
        .padding()
    }
}

struct TagSelectorView: View {
    var tags: [Tag]
    @Binding var selectedTags: [Tag]

    var body: some View {
        VStack {
            if !(selectedTags.count == tags.count){
                HStack {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.blue)
                    Image(systemName: "tag.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.blue)
                    //Text("利用可能なタグ")
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(tags.filter { !selectedTags.contains($0) }, id: \.id) { tag in
                            TagButton(tag: tag, isSelected: false) {
                                selectedTags.append(tag)
                            }
                        }
                    }
                }
            }
            
            if !selectedTags.isEmpty {
            HStack {
                Image(systemName: "checkmark.circle")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.blue)
                Image(systemName: "tag.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.blue)
                //Text("選択されているタグ")
            }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(selectedTags, id: \.id) { tag in
                            TagButton(tag: tag, isSelected: true) {
                                selectedTags.removeAll { $0.id == tag.id }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct TagButton: View {
    var tag: Tag
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        HStack {
            Text(tag.name)
            if isSelected {
                Image(systemName: "xmark.circle.fill")
            }
        }
        .padding(.horizontal)
        .background(isSelected ? Color.blue : Color.gray)
        .foregroundColor(.white)
        .cornerRadius(8)
        .onTapGesture(perform: action)
    }
}
