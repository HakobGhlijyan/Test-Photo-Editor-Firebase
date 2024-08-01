//
//  Extensions.swift
//  TestPhotoEditorFirebase
//
//  Created by Hakob Ghlijyan on 01.08.2024.
//

import SwiftUI

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
    }
}

struct ButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue.gradient)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
}

extension View {
    func textFieldStyleCustom() -> some View {
        self.modifier(TextFieldModifier())
    }
    
    func buttonStyleCustom() -> some View {
        self.modifier(ButtonModifier())
    }
}
