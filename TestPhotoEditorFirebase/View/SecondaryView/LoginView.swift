//
//  LoginView.swift
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

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @Binding var showSignInView: Bool
    @State private var isPresentedSignUpView: Bool = false
    @State private var isPresentedResetPasswordView: Bool = false
    let padding: CGFloat = 16
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                LoginHeader()
                    .padding(.bottom)
                textSecureFieldLayer
                forgotPasswordButtonLayer
                
                if viewModel.isLoading {
                    ProgressView().padding()
                } else {
                    signInButtonLayer
                }
                errorMessageLayer
                Spacer()
                orSignUpButtonsLayer
            }
            .onAppear(perform: {
                viewModel.validateForm()
            })
            .padding(padding)
            .sheet(isPresented: $isPresentedSignUpView, content: {
                SignUpView(showSignInView: $showSignInView)
            })
            .sheet(isPresented: $isPresentedResetPasswordView, content: {
                ResetPasswordView(showSignInView: $showSignInView)
            })
            .navigationTitle("Login Email")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: .constant(viewModel.errorMessage != nil)) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage ?? ""),
                    dismissButton: .default(Text("OK"), action: {
                        viewModel.errorMessage = nil
                    })
                )
            }
        }
    }
}

#Preview {
    NavigationStack {
        LoginView(showSignInView: .constant(false))
    }
}

extension LoginView {
    private var textSecureFieldLayer: some View {
        VStack(spacing: 16.0) {
            // Email TextField
            HStack(spacing: 0.0) {
                Image(systemName: "mail")
                    .font(.title3)
                    .bold()
                    .frame(width: 30)
                    .padding(.trailing, 8)
                
                TextField("Email", text: $viewModel.email)
                    .autocapitalization(.none)
                    .textFieldStyleCustom()
            }
            .overlay(alignment: .trailing) {
                if !viewModel.email.isEmpty {
                    Image(systemName: viewModel.email.isValidEmail() ? "checkmark" : "xmark")
                        .fontWeight(.bold)
                        .foregroundColor(viewModel.email.isValidEmail() ? .green : .red)
                        .offset(x: -(padding + 4))
                        .onTapGesture {
                            viewModel.email = ""
                        }
                }
            }
            // Password SecureField
            HStack(spacing: 0.0) {
                Image(systemName: "lock")
                    .font(.title3)
                    .bold()
                    .frame(width: 30)
                    .padding(.trailing, 8)
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyleCustom()
            }
            .overlay(alignment: .trailing) {
                if !viewModel.password.isEmpty {
                    Image(systemName: viewModel.password.isValidPassword() ? "checkmark" : "xmark")
                        .fontWeight(.bold)
                        .foregroundColor(viewModel.password.isValidPassword() ? .green : .red)
                        .offset(x: -(padding + 4))
                        .onTapGesture {
                            viewModel.password = ""
                        }
                }
            }
        }
    }
    
    private var forgotPasswordButtonLayer: some View {
        HStack(spacing: 0.0) {
            Spacer()
            Button(action: {
                isPresentedResetPasswordView.toggle()
            }, label: {
                Label("Forgot Password?", systemImage: "")
                    .font(.subheadline)
            })
            
                
        }
        .padding(.vertical, 16)
    }
    
    private var signInButtonLayer: some View {
        Button(action: {
            Task {
                try await viewModel.signIn()
                if viewModel.errorMessage == nil {
                    print("presentationMode.wrappedValue.dismiss()")
                    dismiss()
                }
            }
        }, label: {
            Text("Log In")
                .buttonStyleCustom(isDisabled: viewModel.isDisabled)
                .padding(.vertical, 16)
        })
        .disabled(viewModel.isDisabled)
    }
    
    private var errorMessageLayer: some View {
        VStack {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
                    .multilineTextAlignment(.center)
            }
        }
    }
 
    private var orSignUpButtonsLayer: some View {
        VStack {
            Text("OR SIGN UP")
                .font(.headline)
                .padding()
            
            HStack(alignment: .center, spacing: 28.0) {
                GoogleSignInButtonCustom {
                    Task {
                        try await viewModel.signInGoogle()
                    }
                }
                
                Button(action: {
                    isPresentedSignUpView.toggle()
                }, label: {
                    EmailSignInButtonCustom()
                })
            }
        }
    }
}
