//
//  RegisterView.swift
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

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    @Environment(\.dismiss) private var dismiss
    
    @Binding var showSignInView: Bool
    let padding: CGFloat = 16

    var body: some View {
        NavigationStack {
            VStack {
                Text("Register New Account")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)

                textSecureFieldLayer
                
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                } else {
                    signUpButtonLayer
                }
                
                errorMessageLayer
                Spacer()
                lastLogInReturnButtonsLayer
                
                
            }
            .padding()
            .navigationTitle("Sign Up")
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
        SignUpView(showSignInView: .constant(false))
    }
}


extension SignUpView {
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
                if (viewModel.email.count != 0) {
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
                if(viewModel.password.count != 0) {
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
    
    private var signUpButtonLayer: some View {
        Button(action: {
            Task {
                try await viewModel.signUp()
                if viewModel.errorMessage == nil {
                    print("presentationMode.wrappedValue.dismiss()")
                    showSignInView = false
                }
            }
         }, label: {
             Text("Register")
                 .buttonStyleCustom(isDisabled: viewModel.isDisabled)
                 .padding(.vertical, 16)
         })
        .disabled(viewModel.isDisabled)
    }
    
    private var errorMessageLayer: some View {
        //Error
        VStack {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    private var lastLogInReturnButtonsLayer: some View {
        Button(action: {
            dismiss()
        }, label: {
            EmailSignInButtonCustom(title: "Already have an account? Login")
        })
    }
    
}
