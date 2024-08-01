//
//  AuthViewModel.swift
//  TestPhotoEditorFirebase
//
//  Created by Hakob Ghlijyan on 01.08.2024.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import Observation

@Observable final class AuthViewModel {
    var isLoggedIn: Bool = false
    var errorMessage: String?
    var isLoading: Bool = false
    
    func login(email: String, password: String) {
        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            self.isLoading = false
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                self.isLoggedIn = true
            }
        }
    }

    func register(email: String, password: String) {
        isLoading = true
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            self.isLoading = false
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                result?.user.sendEmailVerification { error in
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                    } else {
                        self.isLoggedIn = true
                    }
                }
            }
        }
    }

    func sendPasswordReset(email: String) {
        isLoading = true
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            self.isLoading = false
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                // Handle successful password reset
            }
        }
    }

    func logout() {
        try? Auth.auth().signOut()
        isLoggedIn = false
    }
    
    // Mock Data for Preview
    static var preview: AuthViewModel {
        let authViewModel = AuthViewModel()
        authViewModel.isLoggedIn = false
        return authViewModel
    }
}
