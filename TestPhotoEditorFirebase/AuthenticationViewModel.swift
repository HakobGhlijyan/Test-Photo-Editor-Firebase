//
//  AuthenticationViewModel.swift
//  TestPhotoEditorFirebase
//
//  Created by Hakob Ghlijyan on 01.08.2024.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

@MainActor
final class AuthenticationViewModel: ObservableObject {
    func singInGoogle() async throws {
        let helper = SignInWithGoogleHelper()
        let tokens = try await helper.singIn()
        try await AuthenticationManager.shared.singInWithGoogle(tokens: tokens)
    }
}

struct AuthenticationView: View {
    @StateObject private var viewmodel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
    
    @Bindable var authViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            NavigationLink {

            } label: {
                Text("Sign In white Email")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .cornerRadius(10)
            }
        

            GoogleSigInButtonCustom {
                Task {
                    do {
                        try await viewmodel.singInGoogle()
                        showSignInView = false
                    } catch {
                        print(error)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Sign In")
    }
}

#Preview {
    NavigationStack {
        AuthenticationView(showSignInView: .constant(false), authViewModel: AuthViewModel.preview)
    }
}
