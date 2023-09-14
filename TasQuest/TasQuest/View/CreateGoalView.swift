//
//  CreateGoalView.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/12.
//

import SwiftUI
import Firebase
import FirebaseFirestore

/// ゴールを作成するための半モーダルView
struct CreateGoalHalfModalView: View {
    // モーダルを閉じるための環境変数
    @Environment(\.presentationMode) var presentationMode
    // 選択されたStatusのID
    @State var statusIndex: Int

    // 入力フィールドとトグルの状態
    @State private var selectedDate = Date()
    @State var name: String = ""
    @State var description: String = ""
    @State var dueDate: Date = Date()
    @State var isStarred: Bool = false
    @State var selectedTags: [Tag] = []
    @ObservedObject var keyboard = KeyboardResponder()

    // 画面の本体
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
    /// モーダルのヘッダー部分
    var modalHeader: some View {
        HStack {
            Text("新しいゴールの作成")
                .font(.title)
                .bold()
            Spacer()
        }
        .padding()
    }

    /// 入力フィールドのグループ
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

    /// お気に入りトグル
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

    /// タグ選択部分
    var tagSelection: some View {
        TagSelectorView(selectedTags: $selectedTags) // Todo: Create TagSelectionView
    }

    /// 保存ボタン
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
    
    /// ゴールを保存するロジック
    func saveGoal() {
        // Create a new Goal
        let newGoal = Goal(
            id: "", // Firestore-generated ID
            name: name,
            description: description,
            tasks: [],
            dueDate: selectedDate,
            isStarred: isStarred,
            tags: selectedTags,
            thumbnail: "", // Optional
            createdAt: Date(),
            updatedAt: Date()
        )
        
        // StatusIdからStatusのIndexを取得
        //　該当するStatusに新しいGoalを追加
        AppDataSingleton.shared.appData.statuses[statusIndex].goals.append(newGoal)
        
        // Firestoreに保存
        FirestoreManager.shared.saveAppData() { error in
            if let error = error {
                print("Failed to save data: \(error)")
            } else {
                print("Data saved successfully.")
                // Updateをフェッチしシングルトンオブジェクトを更新
                FirestoreManager.shared.fetchAppData { fetchedAppData in
                    if let fetchedAppData = fetchedAppData {
                        AppDataSingleton.shared.appData = fetchedAppData
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
