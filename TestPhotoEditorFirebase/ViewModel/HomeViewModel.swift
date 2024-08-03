//
//  HomeViewModel.swift
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
final class HomeViewModel: ObservableObject {
    @Published var authProvider: [AuthProviderOption] = []
    
    func loadAuthProvider() {
        if let providers = try? AuthenticationManager.shared.getProviders() {
            authProvider = providers
        }
    }
    
}
