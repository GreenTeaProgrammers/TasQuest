//
//  SignInEmailView.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/06.
//

import SwiftUI


struct SignInEmailView: View {
    @Binding var showSignInView: Bool
    
    @StateObject private var viewModel = SignInEmailViewModel()
    @State private var errorMessage: String? = nil  // New state variable for the error message
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            TextField("メールアドレス", text: $viewModel.email)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            SecureField("パスワード", text: $viewModel.password)
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
                        try await viewModel.signIn()
                        showSignInView = false
                        presentationMode.wrappedValue.dismiss()

                    } catch {
                        errorMessage = viewModel.errorMessage
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
        .navigationTitle("サインイン")
    }
}
