//
//  ResetPasswordView.swift
//  TestPhotoEditorFirebase
//
//  Created by Hakob Ghlijyan on 01.08.2024.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

struct ResetPasswordView: View {
    @StateObject private var viewModel = ResetPasswordViewModel()
    @Binding var showSignInView: Bool
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Do you not remember your password?")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 20)
                
                TextField("Email", text: $viewModel.email)
                    .autocapitalization(.none)
                    .textFieldStyleCustom()
                    .padding(.bottom, 20)
                            
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
                             .buttonStyleCustom(isDisabled: viewModel.isDisabled)
                             .padding(.vertical, 16)
                     })
                    .disabled(viewModel.isDisabled)
                }
                
                if let errorMessage = self.viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Reset Password")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: .constant(viewModel.errorMessage != nil)) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage ?? ""),
                    dismissButton: .default(Text("OK"), action: {
                        viewModel.errorMessage = nil
                        dismiss()
                    })
                )
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    BackButton { dismiss() }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ResetPasswordView(showSignInView: .constant(false))
    }
}
