//
//  LoginHeader.swift
//  TestPhotoEditorFirebase
//
//  Created by Hakob Ghlijyan on 01.08.2024.
//

import SwiftUI

struct LoginHeader: View {
    var body: some View {
        VStack {
            Text("Hello Again!")
                .font(.largeTitle)
                .fontWeight(.medium)
                .padding()
            
            Text("Welcome to back, \nYou've been missed")
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    LoginHeader()
}
