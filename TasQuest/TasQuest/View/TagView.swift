//
//  TagView.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/12.
//

import SwiftUI

struct TagView: View {
    @Binding var appData: AppData  // AppDataをバインディングする
    @State private var showTagEditor: Bool = false  // タグ編集ビューを表示するかどうか
    @State private var editingTag: Tag?  // 編集中のタグ
    
    @State private var reloadFlag: Bool = false

    var body: some View {
        NavigationView {
            List {
                ForEach(appData.tags, id: \.id) { tag in
                    HStack {
                        Circle()
                            .foregroundColor(Color(red: Double(tag.color[0]), green: Double(tag.color[1]), blue: Double(tag.color[2])))
                            .frame(width: 20, height: 20)
                        Text(tag.name)
                        Spacer()
                        Button("編集") {
                            editingTag = tag
                            showTagEditor = true
                        }
                        .foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle("タグ管理")
            .navigationBarItems(trailing: Button(action: {
                editingTag = nil  // 新規作成のため、nilを設定
                showTagEditor = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showTagEditor) {
                TagEditorView(editingTag: $editingTag, appData: $appData)
            }
        }
        .id(reloadFlag)  // 追加
        .onReceive(
            NotificationCenter.default.publisher(for: Notification.Name("TagUpdated")),
            perform: { _ in
                self.reloadFlag.toggle()
            }
        )
    }
}
