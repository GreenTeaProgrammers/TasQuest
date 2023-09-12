//
//  TagEditorView.swift
//  TasQuest
//
//  Created by KijiKawaguchi on 2023/09/12.
//

import SwiftUI

import SwiftUI

struct TagEditorView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var editingTag: Tag?
    @Binding var appData: AppData
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
            if let editingTag = editingTag {
                tagName = editingTag.name
                selectedColor = Color(red: Double(editingTag.color[0]), green: Double(editingTag.color[1]), blue: Double(editingTag.color[2]))
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
        
        if let editingTag = editingTag {
            // Existing tag: Update it
            if let index = appData.tags.firstIndex(where: { $0.id == editingTag.id }) {
                appData.tags[index].name = tagName
                appData.tags[index].color = [Float(red), Float(green), Float(blue)]
                appData.tags[index].updatedAt = Date()
            }
        } else {
            // New tag: Create it
            let newTag = Tag(id: UUID().uuidString, name: tagName, color: [Float(red), Float(green), Float(blue)], createdAt: Date(), updatedAt: Date())
            appData.tags.append(newTag)
        }
        
        // Save to Firestore
        FirestoreManager.shared.saveAppData(appData: appData) { error in
            if let error = error {
                print("Failed to save data: \(error)")
            } else {
                print("Data saved successfully.")
                
                // Force a complete re-render
                NotificationCenter.default.post(name: Notification.Name("TagUpdated"), object: nil)
                
                // Reload data after it has been saved
                FirestoreManager.shared.fetchAppData { fetchedAppData in
                    if let fetchedAppData = fetchedAppData {
                        self.appData = fetchedAppData  // Update the data
                    } else {
                        // Error handling
                    }
                }
            }
        }
    }
}
