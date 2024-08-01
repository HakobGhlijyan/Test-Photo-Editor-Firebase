//
//  HomeView.swift
//  TestPhotoEditorFirebase
//
//  Created by Hakob Ghlijyan on 01.08.2024.
//

import SwiftUI
import PhotosUI

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var authProvider: [AuthProviderOption] = []
    
    func loadAuthProvider() {
        if let providers = try? AuthenticationManager.shared.getProviders() {
            authProvider = providers
        }
    }
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.badURL)
        }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func updateEmail() async throws {
        let emailExample = "gorgsalvatore2@rambler.ru"
        try await AuthenticationManager.shared.updateEmail(email: emailExample)
    }
    
    func updatePassword() async throws {
        let passwordExample = "hakob0"
        try await AuthenticationManager.shared.updatePassword(password: passwordExample)
    }
    
}

struct HomeView: View {
    @StateObject private var viewmodel = HomeViewModel()
    @Binding var showSignInView: Bool

    var body: some View {
        VStack {
            Text("Welcome to the It's Home View!")
                .font(.largeTitle)
                .padding()
                .multilineTextAlignment(.center)
            Spacer()
            PhotoPickerView()
            Spacer()
            Button("Logout") {
                
            }
            .buttonStyleCustom()
            
            List {
                Section("Log Out") {
                    Button("Log Out") {
                        Task {
                            do {
                                try viewmodel.signOut()
                                showSignInView = true
                                print("Log Out")
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
                
                if viewmodel.authProvider.contains(.email) {
                    Section("Update") {
                        Button("Password Update") {
                            Task {
                                do {
                                    try await viewmodel.updatePassword()
                                    print("Password update")
                                } catch {
                                    print(error)
                                }
                            }
                        }
                        
                        Button("Email Update") {
                            Task {
                                do {
                                    try await viewmodel.updateEmail()
                                    print("Email update")
                                } catch {
                                    print(error)
                                }
                            }
                        }
                    }
                    Section("Reset") {
                        Button("Password Reset") {
                            Task {
                                do {
                                    try await viewmodel.resetPassword()
                                    print("Password Reset")
                                } catch {
                                    print(error)
                                }
                            }
                        }
                    }
                }
            }
            .onAppear {
                viewmodel.loadAuthProvider()
            }
            
            .padding(.horizontal, 80)
        }
        .padding()
    }
}

#Preview {
    HomeView(showSignInView: .constant(false))
}
