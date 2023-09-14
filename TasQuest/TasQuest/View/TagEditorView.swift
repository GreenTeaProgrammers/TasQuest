//
//  TagEditorView.swift
//  TasQuest
//
//  Created by KijiKawaguchi on 2023/09/12.
//

import SwiftUI

struct TagEditorView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var tagIndex: Int?  // Optional
    
    @State private var tagName: String = ""
    @State private var selectedColor: Color = Color.red
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("タグ名")) {
                    TextField("タグ名を入力", text: $tagName)
                }
                
                Section(header: Text("色")) {
                    ColorPicker("色を選択", selection: $selectedColor)
                }
            }
            .navigationTitle("タグ編集")
            .navigationBarItems(leading: Button("キャンセル") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("保存") {
                saveTag()
                presentationMode.wrappedValue.dismiss()
            })
        }
        .onAppear {
            if let tagIndex = tagIndex {
                let tag = AppDataSingleton.shared.appData.tags[tagIndex]
                tagName = tag.name
                selectedColor = Color(red: Double(tag.color[0]), green: Double(tag.color[1]), blue: Double(tag.color[2]))
            }
        }
    }
    
    private func saveTag() {
        let uiColor = UIColor(selectedColor)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        if let tagIndex = tagIndex {
            // Existing tag: Update it
            AppDataSingleton.shared.appData.tags[tagIndex].name = tagName
            AppDataSingleton.shared.appData.tags[tagIndex].color = [Float(red), Float(green), Float(blue)]
            AppDataSingleton.shared.appData.tags[tagIndex].updatedAt = Date()
        } else {
            // New tag: Create it
            let newTag = Tag(id: UUID().uuidString, name: tagName, color: [Float(red), Float(green), Float(blue)], createdAt: Date(), updatedAt: Date())
            AppDataSingleton.shared.appData.tags.append(newTag)
        }
        
        // Save to Firestore
        FirestoreManager.shared.saveAppData() { error in
            if let error = error {
                print("Failed to save data: \(error)")
            } else {
                print("Data saved successfully.")
                FirestoreManager.shared.fetchAppData { fetchedAppData in
                    if let fetchedAppData = fetchedAppData {
                        AppDataSingleton.shared.appData = fetchedAppData
                        NotificationCenter.default.post(name: Notification.Name("TagUpDated"), object: nil)//強制的に全体を再レンダリング
                    } else {
                        print("AppDataの取得に失敗しました")
                    }
                }
            }
        }
    }
}
