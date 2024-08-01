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

@MainActor
final class SignUpViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password:String = ""
    @Published var errorMessage: String?
    @Published var alertState: Bool = false
    @Published var isLoading: Bool = false
    
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No Email and Password found!!!")
            return
        }
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
}

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    @State private var showSignInView: Bool = false

    var body: some View {
        VStack {
            Text("Sign Up")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 20)

            TextField("Email", text: $viewModel.email)
                .autocapitalization(.none)
                .textFieldStyleCustom()
            
            SecureField("Password", text: $viewModel.password)
                .textFieldStyleCustom()
            
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else {
                Button("Register") {
                    Task {
                        do {
                            try await viewModel.signIn()
                            showSignInView = false
                            print("Sing IN User")
                            return
                        } catch {
                            self.viewModel.errorMessage = error.localizedDescription
                            print(error)
                        }
                    }
                }
                .buttonStyleCustom()
            }

            NavigationLink("Already have an account? Login", destination: LoginView(showSignInView: $showSignInView))
                .padding(.top, 10)
                .buttonStyle(.bordered)
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Spacer()

            NavigationLink("Already have an account? Login", destination: LoginView(showSignInView: $showSignInView))
                .padding(.top, 10)
                .buttonStyle(.bordered)
        }
        .padding()
        .navigationTitle("Log In")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: .constant(viewModel.errorMessage != nil)) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $viewModel.alertState, content: {
            Alert(title: Text("Success"), message: Text("You Registred \nPlease Log in"), dismissButton: .default(Text("OK")))
        })
    }
}


#Preview {
    NavigationStack {
        SignUpView()
    }
}
