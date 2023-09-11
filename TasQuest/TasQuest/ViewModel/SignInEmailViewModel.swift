//
//  SignInEmailViewModel.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/06.
//

import SwiftUI
import FirebaseAuth

@MainActor
final class SignInEmailViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String? = nil  // New published variable for the error message
    
    func signIn() async throws {
        if isFormEmpty() {
            errorMessage = "Email and password cannot be empty."
            throw NSError(domain: "Form Error", code: 1)
        }
        
        do {
            try await AuthenticationManager.shared.signInUser(email: email, password: password)
        } catch {
            errorMessage = "Failed to sign in."
            throw error
        }
    }
    
    private func isFormEmpty() -> Bool {
        if email.isEmpty || password.isEmpty {
            return true
        }
        return false
    }
}
