//
//  BackButton.swift
//  TestPhotoEditorFirebase
//
//  Created by Hakob Ghlijyan on 03.08.2024.
//

import SwiftUI

struct BackButton: View {
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack{
                Circle()
                    .foregroundColor(.white)
                    .shadow(color: .gray, radius: 4, x: 0, y: 2)
                
                Image(systemName: "arrowshape.backward.fill")
                    .resizable()
                    .scaledToFit()
                    .padding(8)
                    .tint(.gray)
                    .mask(
                        Circle()
                    )
            }
        }
        .frame(width: 40, height: 40)
    }
}


#Preview {
    BackButton {
        //
    }
}
