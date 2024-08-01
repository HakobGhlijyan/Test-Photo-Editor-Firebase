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

struct LoginView: View {
    @Bindable var authViewModel: AuthViewModel
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State var userName: String = ""
    @State var userPassword: String = ""

    var body: some View {
        VStack {
            LoginHeader()
                .padding(.bottom)

            VStack(spacing: 16.0) {
                //1.1
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .textFieldStyleCustom()
                //1.2
                //CustomTextfield(text: $userName, textFiledBandle: "Email")
                
                //2.1
                SecureField("Password", text: $password)
                    .textFieldStyleCustom()
                //2.2
                //CustomTextfield(text: $userPassword, textFiledBandle: "Password")
            }
            
            //
            HStack {
                Spacer()
                Button("Forgot Password?") {
                    
                }
                .font(.subheadline)
            }
            .padding(.vertical, 16)
            
            //
            if authViewModel.isLoading {
                ProgressView()
                    .padding()
            } else {
                LoginButton()
            }
            //
            
            Text("or")
                .padding()
            
            GoogleSigInButton {
                // TODO: - Call the sign method here
            }
            //
            
            
            
            
            
            if let errorMessage = authViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Spacer()
            
            Group {
                NavigationLink("Register", destination: RegisterView(authViewModel: authViewModel))
                    .padding(.top, 10)
                    .buttonStyle(.bordered)
                
                NavigationLink("Forgot Password?", destination: ResetPasswordView(authViewModel: authViewModel))
                    .padding(.top, 10)
                    .buttonStyle(.bordered)
            }
        }
        .padding()
        .alert(isPresented: .constant(authViewModel.errorMessage != nil)) {
            Alert(title: Text("Error"), message: Text(authViewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    NavigationStack {
        LoginView(authViewModel: AuthViewModel.preview)
    }
}
