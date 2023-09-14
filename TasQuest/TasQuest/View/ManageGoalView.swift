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
    @Binding var appData: AppData  // AppDataをBindingで受け取る
    @Binding var status: Status
    
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
        TagSelectorView(tags: appData.tags, selectedTags: $selectedTags)
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
           let goalIndex = status.goals.firstIndex(where: { $0.id == editingGoal.id }) {
            // Update existing goal
            status.goals[goalIndex].name = self.name
            status.goals[goalIndex].description = self.description
            status.goals[goalIndex].dueDate = self.dueDate
            status.goals[goalIndex].isStarred = self.isStarred
            status.goals[goalIndex].tags = self.selectedTags
            status.goals[goalIndex].updatedAt = Date()
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
            status.goals.append(newGoal)
        }
        
        // Save to Firestore
        FirestoreManager.shared.saveAppData(appData: appData) { error in
            if let error = error {
                print("Failed to save data: \(error)")
            } else {
                print("Data saved successfully.")
                
                // Refresh data after saving
                FirestoreManager.shared.fetchAppData { fetchedAppData in
                    if let fetchedAppData = fetchedAppData {
                        self.appData = fetchedAppData  // Update the data
                        NotificationCenter.default.post(name: Notification.Name("StatusUpdate"), object: nil)//強制的に全体を再レンダリング
                    } else {
                        // Handle the error
                    }
                }
            }
            // Close the modal
            presentationMode.wrappedValue.dismiss()
        }
    }
}
