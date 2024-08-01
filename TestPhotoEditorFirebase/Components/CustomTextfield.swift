//
//  CustomTextfield.swift
//  TestPhotoEditorFirebase
//
//  Created by Hakob Ghlijyan on 01.08.2024.
//

import SwiftUI

struct CustomTextfield: View {
    @Binding var text: String
    var textFiledBandle: String
    
    var body: some View {
        TextField(textFiledBandle, text: $text)
            .autocapitalization(.none)
            .padding(16)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke()
            )
    }
}

#Preview {
    Group {
        CustomTextfield(text: .constant("Username"), textFiledBandle: "Username")
        CustomTextfield(text: .constant("Email"), textFiledBandle: "Email")
        CustomTextfield(text: .constant("Password"), textFiledBandle: "Password")
    }
    .padding(.horizontal, 24)
    .padding(.vertical, 12)

}
