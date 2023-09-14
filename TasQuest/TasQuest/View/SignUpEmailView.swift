//
//  SignUpEmailView.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/10.
//

import SwiftUI

/// メールアドレスとパスワードでの新規登録を行うView
struct SignUpEmailView: View {
    /// 認証状態を外部から受け取る
    @Binding var isNotAuthed: Bool
    
    /// ViewModelのインスタンス
    @StateObject private var viewModel = SignUpEmailViewModel()
    /// エラーメッセージを表示するためのState変数
    @State private var errorMessage: String? = nil
    
    /// モーダルを閉じるための環境変数
    @Environment(\.presentationMode) var presentationMode
    
    /// 画面の本体
    var body: some View {
        VStack {
            /// ユーザ名入力フィールド
            TextField("ユーザ名", text: $viewModel.username)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)

            /// メールアドレス入力フィールド
            TextField("メールアドレス", text: $viewModel.email)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            /// パスワード入力フィールド
            SecureField("パスワード（６文字以上）", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            /// エラーメッセージの表示
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            
            /// 新規登録ボタン
            Button {
                Task {
                    do {
                        try await viewModel.signUp()  // ViewModelの新規登録メソッドを呼び出し
                        print("Sign up successful.")
                        DispatchQueue.main.async {
                            isNotAuthed = false
                            presentationMode.wrappedValue.dismiss()
                            // アプリデータを非同期で取得
                            StatusViewModel().fetchAppData { fetchedAppData in
                                if let fetchedAppData = fetchedAppData {
                                    AppDataSingleton.shared.appData = fetchedAppData
                                    NotificationCenter.default.post(name: Notification.Name("StatusUpdated"), object: nil)//強制的に全体を再レンダリング
                                } else {
                                    // エラーハンドリング
                                }
                            }
                        }
                    } catch {
                        print("Sign up failed with error: \(error)")
                        errorMessage = viewModel.errorMessage  // エラーメッセージを設定
                    }
                }
            } label: {
                Text("新規登録")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("新規登録")  // ナビゲーションバーのタイトル
    }
}
