//
//  AuthDataResultModel.swift
//  TasQuest
//
//  Created by KinjiKawaguchi  on 2023/09/07.
//

import FirebaseAuth


struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}
