//
//  ManageGoalView.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/12.
//


import SwiftUI
import Firebase
import FirebaseFirestore

struct ManageGoalView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var statusIndex: Int
    
    // 追加：編集するGoal（オプション）
    var editingGoal: Goal? = nil

    @State private var name: String = ""
    @State private var description: String = ""
    @State private var dueDate: Date = Date()
    @State private var isStarred: Bool = false
    @State private var selectedTags: [Tag] = []
    
    @ObservedObject var keyboard = KeyboardResponder()
    
    var body: some View {
        VStack {
            modalHeader
            ScrollView {
                VStack {
                    inputFields
                    Divider()
                    starToggle
                    Divider()
                    tagSelection
                }
                .padding(.bottom, keyboard.currentHeight)
            }
            saveButton
        }
        .onAppear {
            if let editingGoal = editingGoal {
                self.name = editingGoal.name
                self.description = editingGoal.description
                self.dueDate = editingGoal.dueDate
                self.isStarred = editingGoal.isStarred
                self.selectedTags = editingGoal.tags
            }
        }
        .onAppear { self.keyboard.startObserve() }
        .onDisappear { self.keyboard.stopObserve() }
    }
}

extension ManageGoalView     {
    var modalHeader: some View {
        HStack {
            Text(editingGoal == nil ? "新しいゴールの作成" : "ゴールを編集")
                .font(.title)
                .bold()
            Spacer()
        }
        .padding()
    }
    
    var inputFields: some View {
        Group {
            TextField("ゴールの名前", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            TextField("ゴールの説明", text: $description)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            HStack {
                Image(systemName: "calendar")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.blue)
                DatePicker("", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                Spacer()
            }
            .padding()
        }
    }
    
    var starToggle: some View {
        Toggle(isOn: $isStarred) {
            HStack {
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.yellow)
                Text("お気に入り")
            }
        }
        .padding()
    }
    
    var tagSelection: some View {
        TagSelectorView(selectedTags: $selectedTags)
    }
    
    var saveButton: some View {
        Button(action: saveGoal) {
            HStack {
                Image(systemName: "checkmark")
                Text("保存")
            }
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
    }
    
    func saveGoal() {
        if let editingGoal = editingGoal,
           let goalIndex = AppDataSingleton.shared.appData.statuses[statusIndex].goals.firstIndex(where: { $0.id == editingGoal.id }) {
            // Update existing goal
            AppDataSingleton.shared.appData.statuses[statusIndex].goals[goalIndex].name = self.name
            AppDataSingleton.shared.appData.statuses[statusIndex].goals[goalIndex].description = self.description
            AppDataSingleton.shared.appData.statuses[statusIndex].goals[goalIndex].dueDate = self.dueDate
            AppDataSingleton.shared.appData.statuses[statusIndex].goals[goalIndex].isStarred = self.isStarred
            AppDataSingleton.shared.appData.statuses[statusIndex].goals[goalIndex].tags = self.selectedTags
            AppDataSingleton.shared.appData.statuses[statusIndex].goals[goalIndex].updatedAt = Date()
        } else {
            // Create new goal
            let newGoal = Goal(
                id: "", // Firestore will generate the ID
                name: name,
                description: description,
                tasks: [],
                dueDate: dueDate,
                isStarred: isStarred,
                tags: selectedTags,
                thumbnail: "", // Optional
                createdAt: Date(),
                updatedAt: Date()
            )
            AppDataSingleton.shared.appData.statuses[statusIndex].goals.append(newGoal)
        }
        
        // Save to Firestore
        FirestoreManager.shared.saveAppData() { error in
            if let error = error {
                print("Failed to save data: \(error)")
            } else {
                print("Data saved successfully.")
                // Updateをフェッチしシングルトンオブジェクトを更新
                FirestoreManager.shared.fetchAppData { fetchedAppData in
                    if let fetchedAppData = fetchedAppData {
                        AppDataSingleton.shared.appData = fetchedAppData
                        NotificationCenter.default.post(name: Notification.Name("StatusUpdated"), object: nil)//強制的に全体を再レンダリング
                    } else {
                        // Handle error
                    }
                }
            }
        }
        // Close the modal
        presentationMode.wrappedValue.dismiss()
    }
}
