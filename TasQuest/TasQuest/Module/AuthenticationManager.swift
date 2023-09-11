//
//  AuthenticationManager.swift
//  TasQuest
//
//  Created by KinjiKawaguchi on 2023/09/06.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestore


final class AuthenticationManager{
    
    static let shared = AuthenticationManager()
    private init() { }
    
    func getAuthenticatedUser() throws -> AuthDataResultModel? {
        guard let user = Auth.auth().currentUser else {
            return nil
        }
        return AuthDataResultModel(user: user)
    }

    
    @discardableResult
    func createUser(username: String, email: String, password: String) async throws ->  AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func createUserData(userid: String, username:String) {
        let currentTime = Date()
        let newData: AppData = AppData(userid: userid, username: username, statuses: [Status(id:"0", name:"未着手", goals:[], updatedAt: currentTime),Status(id:"1", name:"対応中", goals:[], updatedAt: currentTime),Status(id:"2", name:"完了", goals:[], updatedAt: currentTime)], tags: [], createdAt: currentTime)
        FirestoreManager.shared.saveAppData(appData: newData) { error in
            if let error = error {
                print("Failed to save data: \(error)")
            } else {
                print("Data saved successfully.")
            }
        }
    }
    
    @discardableResult
    func signInUser(email: String, password: String) async throws ->  AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
        
    }
}
