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
    var isDisabled: Bool
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundStyle(.white)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(isDisabled ? .gray : .blue)
            .cornerRadius(10)
    }
}

extension View {
    func textFieldStyleCustom() -> some View {
        self.modifier(TextFieldModifier())
    }
    
    func buttonStyleCustom(isDisabled: Bool) -> some View {
        self.modifier(ButtonModifier(isDisabled: isDisabled))
    }
}

extension String {
    func isValidEmail() -> Bool {
        // Пример проверки email. Реализуйте по вашему усмотрению.
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        // Пример проверки пароля. Реализуйте по вашему усмотрению.
        return self.count >= 8
    }
}
