//
//  emialSignInButtonCustom.swift
//  TestPhotoEditorFirebase
//
//  Created by Hakob Ghlijyan on 01.08.2024.
//

import SwiftUI

struct EmailSignInButtonCustom: View {
    var title: String?
    
    var body: some View {
        GroupBox {
            HStack(spacing: 8) {
                Image(systemName: "envelope.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                Text("Mail")
                    .font(.headline)
                Text("\(title ?? "")")
                    .font(.subheadline)
            }
            .tint(.primary)
        }
        .groupBoxStyle(.customBox)
    }
}

#Preview {
    EmailSignInButtonCustom()
}

struct CustomGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
                .bold()
                .foregroundStyle(.pink)
            configuration.content
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

extension GroupBoxStyle where Self == CustomGroupBoxStyle {
    static var customBox: CustomGroupBoxStyle { .init() }
}
