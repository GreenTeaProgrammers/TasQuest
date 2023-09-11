//
//  SignUpViewModel.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/10.
//

import FirebaseAuth

@MainActor
final class SignUpEmailViewModel: ObservableObject {
    
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String? = nil  // New published variable for the error message
    
    func signUp() async throws {
        if isFormEmpty() {
            errorMessage = "Email and password cannot be empty."
            throw NSError(domain: "Form Error", code: 1)
        }
        
        do {
            let authModel:AuthDataResultModel = try await AuthenticationManager.shared.createUser(username: username, email: email, password: password)
            AuthenticationManager.shared.createUserData(userid: authModel.uid, username: username)
        } catch {
            errorMessage = "Failed to sign up."
            throw error
        }
    }
    
    private func isFormEmpty() -> Bool {
        if username.isEmpty || email.isEmpty || password.isEmpty {
            return true
        }
        return false
    }
}
