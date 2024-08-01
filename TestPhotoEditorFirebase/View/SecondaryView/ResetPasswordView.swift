//
//  ResetPasswordView.swift
//  TestPhotoEditorFirebase
//
//  Created by Hakob Ghlijyan on 01.08.2024.
//

import SwiftUI

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

@MainActor
final class ResetPasswordViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    func resetPassword() async throws {
        isLoading = true
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        guard let email = authUser.email else {
            isLoading = false
            throw URLError(.badURL)
        }
        try await AuthenticationManager.shared.resetPassword(email: email)
        isLoading = false
    }
}

struct ResetPasswordView: View {
    @StateObject private var viewModel = ResetPasswordViewModel()
    
    var body: some View {
        VStack {
            Text("Do you not remember your password?")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.bottom, 20)
            
            TextField("Email", text: $viewModel.email)
                .autocapitalization(.none)
                .textFieldStyleCustom()
                .padding(.bottom, 20)
            
//            CustomTextfield(text: $viewModel.email, textFiledBandle: "Email")
//                .padding(.bottom, 20)
            
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else {
                Button(action: {
                    Task {
                        do {
                            try await viewModel.resetPassword()
                            print("Password Reset")
                        } catch {
                            self.viewModel.errorMessage = error.localizedDescription
                            print(error)
                        }
                    }
                 }, label: {
                     Text("Send Reset Link")
                         .buttonStyleCustom()
                 })
            }
            
            if let errorMessage = self.viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Reset Password")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: .constant(viewModel.errorMessage != nil)) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    NavigationStack {
        ResetPasswordView()
    }
}
