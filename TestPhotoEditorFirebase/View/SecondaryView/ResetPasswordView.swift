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

struct ResetPasswordView: View {
    @Bindable var authViewModel: AuthViewModel
    @State private var email: String = ""
    
    var body: some View {
        VStack {
            Text("Reset Password")
                .font(.largeTitle)
                .padding(.bottom, 20)
            
            TextField("Email", text: $email)
                .autocapitalization(.none)
                .textFieldStyleCustom()
            
            if authViewModel.isLoading {
                ProgressView()
                    .padding()
            } else {
                Button("Send Reset Link") {
                    authViewModel.sendPasswordReset(email: email)
                }
                .buttonStyleCustom()
            }
            
            if let errorMessage = authViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Spacer()
        }
        .padding()
        .alert(isPresented: .constant(authViewModel.errorMessage != nil)) {
            Alert(title: Text("Error"), message: Text(authViewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    NavigationStack {
        ResetPasswordView(authViewModel: AuthViewModel.preview)
    }
}
