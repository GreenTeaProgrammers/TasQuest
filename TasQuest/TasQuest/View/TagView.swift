//
//  TagView.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/12.
//

import SwiftUI

struct TagView: View {
    @State private var showTagEditor: Bool = false
    
    @State var editingTagIndex: Int?  // この変数にインデックスを格納
    
    @State private var reloadFlag: Bool = false

    var body: some View {
        NavigationView {
            List {
                ForEach(AppDataSingleton.shared.appData.tags, id: \.id) { tag in
                    HStack {
                        Circle()
                            .foregroundColor(Color(red: Double(tag.color[0]), green: Double(tag.color[1]), blue: Double(tag.color[2])))
                            .frame(width: 20, height: 20)
                        Text(tag.name)
                        Spacer()
                        Button("編集") {
                            // インデックスを検索してeditingTagIndexに格納
                            if let index = AppDataSingleton.shared.appData.tags.firstIndex(where: { $0.id == tag.id }) {
                                editingTagIndex = index
                            }
                            showTagEditor = true
                        }
                        .foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle("タグ管理")
            .navigationBarItems(trailing: Button(action: {
                editingTagIndex = nil  // 新規作成のため、nilを設定
                showTagEditor = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showTagEditor) {
                TagEditorView(tagIndex: editingTagIndex)  // editingTagIndexを渡す
            }
        }
        .id(reloadFlag)
        .onReceive(
            NotificationCenter.default.publisher(for: Notification.Name("TagUpdated")),
            perform: { _ in
                self.reloadFlag.toggle()
            }
        )
    }
}
