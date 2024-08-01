//
//  PhotoPickerView.swift
//  TestPhotoEditorFirebase
//
//  Created by Hakob Ghlijyan on 01.08.2024.
//

import SwiftUI

import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    
    @StateObject private var viewModel = PhotoPickerViewModel()
    
    //Angle State is Start
    @State var angle:Angle = Angle(degrees: 0)
    
    var body: some View {
        VStack {
            PhotosPicker(selection: $viewModel.imageSelection, matching: .images) {
                Text("Open The Photo Picker")
                    .foregroundStyle(.white)
            }
            .buttonStyleCustom()
            .padding()
            
            VStack {
                if let image = viewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    //Angle
                        .rotationEffect(angle)
                    //gesture
                        .gesture(
                            RotationGesture()
                                .onChanged { value in
                                    angle = value
                                }
                                .onEnded { value in
                                    withAnimation(.spring()){
                                        angle = Angle(degrees: 0)
                                    }
                                }
                        )
                }
            }
            .padding()
        }
    }
}


#Preview {
    PhotoPickerView()
}
