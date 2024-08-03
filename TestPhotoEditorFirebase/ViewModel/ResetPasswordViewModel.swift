//
//  ResetPasswordViewModel.swift
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
final class ResetPasswordViewModel: ObservableObject {
    @Published var email: String = "" {
        didSet {
            validateForm()
        }
    }
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var isDisabled: Bool = true
    
    var isFormValid: Bool {
        !email.isEmpty && email.isValidEmail()
    }
    
    func validateForm() {
        isDisabled = !isFormValid
    }
    
    func resetPassword() async throws {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await AuthenticationManager.shared.resetPassword(email: email)
            errorMessage = "Your password reset sen email, \nplease set new password!"
        } catch {
            errorMessage = error.localizedDescription
        }
        
        
    }
}
