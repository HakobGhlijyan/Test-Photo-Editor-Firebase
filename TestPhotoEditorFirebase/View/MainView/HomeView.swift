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
        let emailExample = "google@g.com"
        try await AuthenticationManager.shared.updateEmail(email: emailExample)
    }
    
    func updatePassword() async throws {
        let passwordExample = "hakob0"
        try await AuthenticationManager.shared.updatePassword(password: passwordExample)
    }
    
}

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @Binding var showSignInView: Bool
    @State private var selection: Int = 1

    var body: some View {
        TabView(selection: $selection) {
            //1
            NavigationStack {
                ScrollView {
                    VStack(spacing: 0.0) {
                        Text("Welcome to the It's Home View!")
                            .font(.largeTitle)
                            .padding()
                            .multilineTextAlignment(.center)
                        
                        PhotoPickerView()
                    }
                }
                .navigationTitle("Photo")
            }
            .tabItem { Label("Photo", systemImage: "photo") }
            .tag(1)
            
            //2
            NavigationStack {
                    List {
                        Section("Log Out") {
                            Button("Log Out") {
                                Task {
                                    do {
                                        try viewModel.signOut()
                                        showSignInView = true
                                        print("Log Out")
                                    } catch {
                                        print(error)
                                    }
                                }
                            }
                        }
                        
                        if viewModel.authProvider.contains(.email) {
                            Section("Update") {
                                Button("Password Update") {
                                    Task {
                                        do {
                                            try await viewModel.updatePassword()
                                            print("Password update")
                                        } catch {
                                            print(error)
                                        }
                                    }
                                }
                                
                                Button("Email Update") {
                                    Task {
                                        do {
                                            try await viewModel.updateEmail()
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
                                            try await viewModel.resetPassword()
                                            print("Password Reset")
                                        } catch {
                                            print(error)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .navigationTitle("Settings")
            }
            .tabItem { Label("Settings", systemImage: "gear") }
            .tag(2)
        }
        .onAppear {
            viewModel.loadAuthProvider()
        }
    }
}

#Preview {
    HomeView(showSignInView: .constant(false))
}
