//
//  SignUpEmailView.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/10.
//

import SwiftUI


struct SignUpEmailView: View {
    @Binding var isNotAuthed: Bool
    
    @StateObject private var viewModel = SignUpEmailViewModel()
    @State private var errorMessage: String? = nil  // New state variable for the error message
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            TextField("ユーザ名", text: $viewModel.username)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)

            TextField("メールアドレス", text: $viewModel.email)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            SecureField("パスワード（６文字以上）", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            if let errorMessage = errorMessage {  // Displaying the error message
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            
            Button {
                Task {
                    do {
                        try await viewModel.signUp()
                        print("Sign up successful.")  // Debug line
                        DispatchQueue.main.async {
                            isNotAuthed = false
                            presentationMode.wrappedValue.dismiss()
                        }
                    } catch {
                        print("Sign up failed with error: \(error)")  // Debug line
                        errorMessage = viewModel.errorMessage
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
        .navigationTitle("新規登録")
    }
}
