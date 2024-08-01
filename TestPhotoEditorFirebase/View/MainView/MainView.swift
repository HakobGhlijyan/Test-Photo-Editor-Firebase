//
//  MainView.swift
//  TestPhotoEditorFirebase
//
//  Created by Hakob Ghlijyan on 01.08.2024.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

struct MainView: View {    
    
    @State private var authViewModel = AuthViewModel()
    
    var body: some View {
        Group {
            if authViewModel.isLoggedIn {
                HomeView(authViewModel: authViewModel)
            } else {
                NavigationStack {
                    LoginView(authViewModel: authViewModel)
                }
            }
        }
        .environment(authViewModel)
    }
}

#Preview {
    MainView()
        .environment(AuthViewModel.preview)
}
