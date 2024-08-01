//
//  HomeView.swift
//  TestPhotoEditorFirebase
//
//  Created by Hakob Ghlijyan on 01.08.2024.
//

import SwiftUI
import PhotosUI

struct HomeView: View {
    @Bindable var authViewModel: AuthViewModel

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
                authViewModel.logout()
            }
            .buttonStyleCustom()
            .padding(.horizontal, 80)
        }
        .padding()
    }
}

#Preview {
    HomeView(authViewModel: AuthViewModel.preview)
}
