import SwiftUI

struct StatusView: View {
    @State private var showSignInView: Bool = false
    @State private var showSettingView: Bool = false

    // ダミーデータ
    let user: AppData = setDummyData()

    func backgroundColor(for index: Int) -> Color {
        switch index {
        case 0: return Color.red
        case 1: return Color.green
        case 2: return Color.blue
        default: return Color.gray
        }
    }

    var body: some View {
        VStack {
            // ウェルカムメッセージと設定ボタン
            HStack {
                Text("ようこそ \(user.username)")
                    .font(.headline)
                Spacer()

                Button(action: {
                    showSettingView = true
                }) {
                    Image(systemName: "gear")
                        .resizable()
                        .frame(width: 24, height: 24)
                }.sheet(isPresented: $showSettingView) {
                    SettingView(showSignInView: $showSignInView)
                }
            }
            .padding()

            // ステータスとその目標を表示
            ForEach(user.statuses.indices, id: \.self) { index in
                let status = user.statuses[index]

                VStack {
                    Text(status.name)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top)

                    ForEach(status.goals, id: \.id) { goal in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(goal.name)
                                Text(goal.dueDate)
                            }

                            Spacer()

                            Button(action: {
                                // Star button tapped
                            }) {
                                Image(systemName: goal.isStarred ? "star.fill" : "star")
                                    .foregroundColor(goal.isStarred ? .yellow : .gray)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()
                .background(backgroundColor(for: index))
                .cornerRadius(15)
                .padding(.bottom)
            }
        }
        .fullScreenCover(isPresented: $showSignInView) {
            AuthenticationView(showSignInView: $showSignInView)
        }
        .onAppear() {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
        }
        Spacer()
    }
}




func setDummyData() -> AppData{
    return AppData(userid: "1", username: "Kinji", statuses: [
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
}
