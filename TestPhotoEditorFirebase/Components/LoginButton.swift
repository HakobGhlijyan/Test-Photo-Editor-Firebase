//
//  LoginButton.swift
//  TestPhotoEditorFirebase
//
//  Created by Hakob Ghlijyan on 01.08.2024.
//

import SwiftUI

struct LoginButton: View {
    var body: some View {
        Button(action: {
            
        }) {
            HStack {
                Spacer()
                Text("Login")
                    .foregroundColor(.white)
                    .font(.headline)
                Spacer()
            }
        }
        .padding()
        .background(.blue.gradient)
        .cornerRadius(12)
    }
}


#Preview {
    LoginButton()
}
