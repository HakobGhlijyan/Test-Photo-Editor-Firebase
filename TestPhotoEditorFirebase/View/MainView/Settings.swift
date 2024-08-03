//
//  Settings.swift
//  TestPhotoEditorFirebase
//
//  Created by Hakob Ghlijyan on 03.08.2024.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

struct Settings: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
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
                        Button("Password Update") { }
                        
                        Button("Email Update") { }
                    }
                    Section("Reset") {
                        Button("Password Reset") { }
                    }
                }
            }
            .navigationTitle("Settings")
            .onAppear {
                viewModel.loadAuthProvider()
            }
        }
    }
}


#Preview {
    Settings(showSignInView: .constant(false))
}
