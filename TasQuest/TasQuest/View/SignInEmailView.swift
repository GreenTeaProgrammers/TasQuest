//
//  SignInEmailView.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/06.
//

import SwiftUI

/// メールアドレスとパスワードでのサインインを行うView
struct SignInEmailView: View {
    /// 認証状態を外部から受け取る
    @Binding var isNotAuthed: Bool
    
    /// ViewModelのインスタンス
    @StateObject private var viewModel = SignInEmailViewModel()
    /// エラーメッセージを表示するためのState変数
    @State private var errorMessage: String? = nil
    
    /// モーダルを閉じるための環境変数
    @Environment(\.presentationMode) var presentationMode
    
    /// 画面の本体
    var body: some View {
        VStack {
            /// メールアドレス入力フィールド
            TextField("メールアドレス", text: $viewModel.email)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            /// パスワード入力フィールド
            SecureField("パスワード", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            /// エラーメッセージの表示
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            
            /// サインインボタン
            Button {
                Task {
                    do {
                        try await viewModel.signIn()  // ViewModelのサインインメソッドを呼び出し
                        print("Sign in successful.")
                        DispatchQueue.main.async {
                            isNotAuthed = false
                            presentationMode.wrappedValue.dismiss()
                            // アプリデータを非同期で取得
                            StatusViewModel().fetchAppData { fetchedAppData in
                                if let fetchedAppData = fetchedAppData {
                                    AppDataSingleton.shared.appData = fetchedAppData
                                } else {
                                    // エラーハンドリング
                                }
                            }
                        }
                    } catch {
                        print("Sign in failed with error: \(error)")
                        errorMessage = viewModel.errorMessage  // エラーメッセージを設定
                    }
                }
            } label: {
                Text("サインイン")
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
        .navigationTitle("サインイン")  // ナビゲーションバーのタイトル
    }
}
