//
//  AuthDataResultModel.swift
//  TestPhotoEditorFirebase
//
//  Created by Hakob Ghlijyan on 05.08.2024.
//

import SwiftUI
import Firebase
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
