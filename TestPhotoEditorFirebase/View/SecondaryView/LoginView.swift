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

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password:String = ""
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No Email and Password found!!!")
            return
        }
        try await AuthenticationManager.shared.createUser(email: email, password: password)
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No Email and Password found!!!")
            return
        }
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
    
    func singInGoogle() async throws {
        let helper = SignInWithGoogleHelper()
        let tokens = try await helper.singIn()
        try await AuthenticationManager.shared.singInWithGoogle(tokens: tokens)
    }
}

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            LoginHeader()
                .padding(.bottom)

            VStack(spacing: 16.0) {
                //1.1
                TextField("Email", text: $viewModel.email)
                    .autocapitalization(.none)
                    .textFieldStyleCustom()
                //1.2
                //CustomTextfield(text: $viewModel.email, textFiledBandle: "Email")
                
                //2.1
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyleCustom()
                //2.2
                //CustomTextfield(text: $viewModel.password, textFiledBandle: "Password")
            }
            
            HStack {
                Spacer()
                NavigationLink("Forgot Password?", destination: ResetPasswordView())
                    .font(.subheadline)
            }
            .padding(.vertical, 16)
            
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else {
                Button("Log In") {
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
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            Spacer()

            Text("OR")
                .font(.headline)
                .padding()
            
            HStack(alignment: .top, spacing: 28.0) {
                GoogleSigInButtonCustom {
                    Task {
                        do {
                            try await viewModel.singInGoogle()
                            showSignInView = false
                        } catch {
                            self.viewModel.errorMessage = error.localizedDescription
                            print(error)
                        }
                    }
                }
                
                NavigationLink("Sing Up With Email", destination: SignUpView())
                    .padding(.top, 10)
                    .buttonStyle(.bordered)
                
            }
            
        }
        .padding()
        .navigationTitle("Log In With Email")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: .constant(viewModel.errorMessage != nil)) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    NavigationStack {
        LoginView(showSignInView: .constant(false))
    }
}
