//
//  CreateGoalView.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/12.
//


import SwiftUI
import Firebase
import FirebaseFirestore

struct CreateGoalHalfModalView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var appData: AppData  // AppDataをBindingで受け取る
    @Binding var status: Status

    @State private var selectedDate = Date()
    @State var name: String = ""
    @State var description: String = ""
    @State var dueDate: Date = Date()
    @State var isStarred: Bool = false
    @State var selectedTags: [Tag] = []
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
        .onAppear { self.keyboard.startObserve() }
        .onDisappear { self.keyboard.stopObserve() }
    }
}

// MARK: - Subviews
extension CreateGoalHalfModalView {
    var modalHeader: some View {
        HStack {
            Text("新しいゴールの作成")
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
                DatePicker("", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
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
                Text("作成")
            }
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
    }
    
    func saveGoal() {
        let newGoal = Goal(
            id: "", // Firestoreが生成するID
            name: name,
            description: description,
            tasks: [],
            dueDate: selectedDate,
            isStarred: isStarred,
            tags: selectedTags,
            thumbnail: "", // オプションで設定
            createdAt: Date(),
            updatedAt: Date()
        )

        // Statusの参照を取得
        if let statusIndex = appData.statuses.firstIndex(where: { $0.id == status.id }) {
            
            // 新しいゴールを追加
            appData.statuses[statusIndex].goals.append(newGoal)
               
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
