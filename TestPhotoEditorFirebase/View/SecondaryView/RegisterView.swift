//
//  RegisterView.swift
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

struct RegisterView: View {
    @Bindable var authViewModel: AuthViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var alertState: Bool = false
    
    var body: some View {
        VStack {
            Text("Register")
                .font(.largeTitle)
                .padding(.bottom, 20)

            TextField("Email", text: $email)
                .autocapitalization(.none)
                .textFieldStyleCustom()
            
            SecureField("Password", text: $password)
                .textFieldStyleCustom()
            
            if authViewModel.isLoading {
                ProgressView()
                    .padding()
            } else {
                Button("Register") {
                    authViewModel.register(email: email, password: password)
                    alertState = true
                }
                .buttonStyleCustom()
            }

            NavigationLink("Already have an account? Login", destination: LoginView(authViewModel: authViewModel))
                .padding(.top, 10)
                .buttonStyle(.bordered)
            
            if let errorMessage = authViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Spacer()

            NavigationLink("Already have an account? Login", destination: LoginView(authViewModel: authViewModel))
                .padding(.top, 10)
                .buttonStyle(.bordered)
        }
        .padding()
        .alert(isPresented: .constant(authViewModel.errorMessage != nil)) {
            Alert(title: Text("Error"), message: Text(authViewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $alertState, content: {
            Alert(title: Text("Success"), message: Text("You Registred \nPlease Log in"), dismissButton: .default(Text("OK")))
        })
    }
}


#Preview {
    NavigationStack {
        RegisterView(authViewModel: AuthViewModel.preview)
    }
}
