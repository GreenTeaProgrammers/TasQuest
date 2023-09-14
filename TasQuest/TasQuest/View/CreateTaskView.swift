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
    @State var statusIndex: Int
    @State var goalIndex: Int

    @State private var selectedDate = Date()
    @State var name: String = ""
    @State var description: String = ""
    @State var dueDate: Date = Date()
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

    func saveTask() {
        if currentHealth > maxHealth {
            currentHealth = maxHealth
        }

        let newTask = TasQuestTask(
            id: "",
            name: name,
            description: description,
            dueDate: selectedDate,
            maxHealth: Float(maxHealth),
            currentHealth: Float(currentHealth),
            tags: selectedTags,
            isVisible: true,
            createdAt: Date(),
            updatedAt: Date()
        )

        AppDataSingleton.shared.appData.statuses[statusIndex].goals[goalIndex].tasks.append(newTask)
        
        FirestoreManager.shared.saveAppData() { error in
            if let error = error {
                print("Failed to save data: \(error)")
            } else {
                print("Data saved successfully.")
                FirestoreManager.shared.fetchAppData { fetchedAppData in
                    if let fetchedAppData = fetchedAppData {
                        AppDataSingleton.shared.appData = fetchedAppData
                        NotificationCenter.default.post(name: Notification.Name("TaskUpdated"), object: nil)//強制的に全体を再レンダリング
                    } else {
                        print("AppDataの取得に失敗しました")
                    }
                }
            }
        }
        // モーダルを閉じる
        presentationMode.wrappedValue.dismiss()
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
                Image(systemName: "calendar")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.blue)
                DatePicker("", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                Spacer()
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

            HStack {
                Image(systemName: "heart.slash.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.red)
                Text("現在")
                HealthSlider(label: "", value: $currentHealth, range: 0...maxHealth)
            }
            .padding()
        }
    }

    var tagSelection: some View {
        TagSelectorView(selectedTags: $selectedTags)
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
    @Binding var selectedTags: [Tag]
    
    var body: some View {
        let tags: [Tag] = AppDataSingleton.shared.appData.tags
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
