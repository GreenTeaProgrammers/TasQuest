import SwiftUI

struct StatusView: View {
    @Binding var showSignInView: Bool
    @State private var showSettingView = false
    @State private var isExpanded: [Bool] = Array(repeating: true, count: 3)  // 3はステータスの数。この数を適切な値に変更してください。

    // ダミーデータ
    let user: AppData = AppData(userid: "1", username: "Kinji", statuses: [
        Status(id: "1", name: "対応前", goals: [
            Goal(id: "1", name: "Goal 1", description: "", tasks: [], dueDate: "2023-09-20", isStarred: false, tags: [], thumbnail: "", createdAt: "", updatedAt: ""),
            Goal(id: "2", name: "Goal 2", description: "", tasks: [], dueDate: "2023-10-01", isStarred: true, tags: [], thumbnail: "", createdAt: "", updatedAt: "")
        ], updatedAt: ""),
        Status(id: "2", name: "対応中", goals: [
            Goal(id: "3", name: "Goal 3", description: "", tasks: [], dueDate: "2023-09-22", isStarred: false, tags: [], thumbnail: "", createdAt: "", updatedAt: "")
        ], updatedAt: ""),
        Status(id: "3", name: "完了", goals: [
            Goal(id: "4", name: "Goal 4", description: "", tasks: [], dueDate: "2023-09-19", isStarred: true, tags: [], thumbnail: "", createdAt: "", updatedAt: "")
        ], updatedAt: "")
    ], tags: [])

    init(showSignInView: Binding<Bool>) {
        _showSignInView = showSignInView
    }

    
    var body: some View {
        VStack {
            // ウェルカムメッセージと設定ボタン
            HStack {
                Text("ようこそ \(user.username)")
                    .font(.headline)
                Spacer()
                
                NavigationLink("", destination: SettingView(showSignInView: $showSignInView), isActive: $showSettingView)
                    .opacity(0)
                
                Button(action: {
                    self.showSettingView = true  // ナビゲーションをトリガー
                }) {
                    Image(systemName: "gear")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
            .padding()
            
            // ステータスとその目標を表示
            List {
                ForEach(user.statuses.indices, id: \.self) { index in
                    DisclosureGroup("\(user.statuses[index].name) (\(user.statuses[index].goals.count))", isExpanded: $isExpanded[index]) {
                        ForEach(user.statuses[index].goals) { goal in
                            HStack {
                                Text(goal.name)
                                Spacer()
                                Text(goal.dueDate)
                                Button(action: {
                                    // ViewModelを使ってtoggleIsStarredメソッドを呼び出す
                                    // ここでの`viewModel`はこのViewで定義されたもの、または親から渡されたものである必要があります。
                                    StatusViewModel(goal: goal).toggleIsStarred()
                                }) {
                                    Image(systemName: goal.isStarred ? "star.fill" : "star")
                                }

                            }
                        }
                    }
                }
            }
        }
    }
}
