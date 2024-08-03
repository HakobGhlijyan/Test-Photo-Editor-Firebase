//
//  SignUpViewModel.swift
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
final class SignUpViewModel: ObservableObject {
    @Published var email: String = "" {
        didSet {
            validateForm()
        }
    }
    @Published var password: String = "" {
        didSet {
            validateForm()
        }
    }
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var isDisabled: Bool = true
    
    var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty && email.isValidEmail() && password.isValidPassword()
    }
    
    func validateForm() {
        isDisabled = !isFormValid
    }
    
    func signUp() async throws {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await AuthenticationManager.shared.createUser(email: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
}
