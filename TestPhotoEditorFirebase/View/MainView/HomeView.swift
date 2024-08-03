//
//  HomeView.swift
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
import PhotosUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @Binding var showSignInView: Bool
    @State private var selection: Int = 1

    var body: some View {
        TabView(selection: $selection) {
            //1
            NavigationStack {
                PhotoPickerView()
                    .navigationTitle("Photo")
            }
            .tabItem { Label("Photo", systemImage: "photo") }
            .tag(1)
            
            //2
            NavigationStack {
                Settings(showSignInView: $showSignInView)
                    .navigationTitle("Settings")
            }
            .tabItem { Label("Settings", systemImage: "gear") }
            .tag(2)
        }
    }
}

#Preview {
    HomeView(showSignInView: .constant(false))
}

