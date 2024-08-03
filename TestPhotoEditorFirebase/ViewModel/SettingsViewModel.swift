//
//  SettingsViewModel.swift
//  TestPhotoEditorFirebase
//
//  Created by Hakob Ghlijyan on 03.08.2024.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var authProvider: [AuthProviderOption] = []
    
    func loadAuthProvider() {
        if let providers = try? AuthenticationManager.shared.getProviders() {
            authProvider = providers
        }
    }
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.badURL)
        }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func updateEmail() async throws {
        let emailExample = "google@g.com"
        try await AuthenticationManager.shared.updateEmail(email: emailExample)
    }
    
    func updatePassword() async throws {
        let passwordExample = "hakob0"
        try await AuthenticationManager.shared.updatePassword(password: passwordExample)
    }
    
}
