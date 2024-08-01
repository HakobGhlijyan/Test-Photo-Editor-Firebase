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
    
    func signIn() async throws {
        isLoading = true
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "No Email and Password found!!!"
            return
        }
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
        isLoading = false
    }
    
    func signUp() async throws {
        isLoading = true
        guard !email.isEmpty, !password.isEmpty else {
            self.errorMessage = "Please entre Email and password!!!"
            return
        }
        try await AuthenticationManager.shared.createUser(email: email, password: password)
        isLoading = false
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
    @State var isPresentedSignUpView: Bool = false
    let padding: CGFloat = 16
    
    var body: some View {
        VStack {
            LoginHeader()
                .padding(.bottom)

            VStack(spacing: 16.0) {
                HStack(spacing: 0.0) {
                    Image(systemName: "mail")
                        .font(.title3)
                        .bold()
                        .frame(width: 30)
                        .padding(.trailing, 8)
                    //1.1
                    TextField("Email", text: $viewModel.email)
                        .autocapitalization(.none)
                        .textFieldStyleCustom()
                    //1.2
//                    CustomTextfield(text: $viewModel.email, textFiledBandle: "Email")
                }
                .overlay(alignment: .trailing) {
                    if (viewModel.email.count != 0) {
                        Image(systemName: viewModel.email.isValidEmail() ? "checkmark" : "xmark")
                            .fontWeight(.bold)
                            .foregroundColor(viewModel.email.isValidEmail() ? .green : .red)
                            .offset(x: -(padding + 4))
                    }
                }

                HStack(spacing: 0.0) {
                    Image(systemName: "lock")
                        .font(.title3)
                        .bold()
                        .frame(width: 30)
                        .padding(.trailing, 8)
                    //2.1
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyleCustom()
                    //2.2
                    //CustomTextfield(text: $viewModel.password, textFiledBandle: "Password")
                }
                .overlay(alignment: .trailing) {
                    if(viewModel.password.count != 0) {
                        Image(systemName: isValidPassword(viewModel.password) ? "checkmark" : "xmark")
                            .fontWeight(.bold)
                            .foregroundColor(isValidPassword(viewModel.password) ? .green : .red)
                            .offset(x: -(padding + 4))
                    }
                }
            }
            
            HStack(spacing: 0.0) {
                Spacer()
                NavigationLink("Forgot Password?", destination: ResetPasswordView(showSignInView: $showSignInView))
                    .font(.subheadline)
            }
            .padding(.vertical, 16)
            .background()
            
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else {
                Button(action: {
                    Task {
                        do {
                            try await viewModel.signIn()
                            showSignInView = false
                            print("Sing IN User")
                            return
                        } catch {
                            self.viewModel.errorMessage = error.localizedDescription
                            self.viewModel.isLoading = false

                            print(error)
                        }
                    }
                }, label: {
                    Text("Log In")
                        .buttonStyleCustom()
                })
                
            }
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
                    .multilineTextAlignment(.center)
            }
            
            Spacer()

            Text("OR SIGN UP")
                .font(.headline)
                .padding()
            
            HStack(alignment: .center, spacing: 28.0) {
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
                
                Button(action: {
                    isPresentedSignUpView.toggle()
                }, label: {
                    EmailSignInButtonCustom()
                })
            }
        }
        .padding(padding)
        .sheet(isPresented: $isPresentedSignUpView, content: {
            SignUpView(showSignInView: $showSignInView)
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

#Preview {
    NavigationStack {
        LoginView(showSignInView: .constant(false))
    }
}
