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
        VStack(spacing: 40.0) {
            //1
            if let image = viewModel.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
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
            
            PhotosPicker(selection: $viewModel.imageSelection, matching: .images) {
                Text("Open one : The Photo Picker")
                    .foregroundStyle(.red)
            }
            
            //2
            if !viewModel.selectedImages.isEmpty {
                ScrollView(.horizontal, showsIndicators: false, content: {
                    HStack {
                        ForEach(viewModel.selectedImages, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        }
                    }
                })
            }
            
            PhotosPicker(selection: $viewModel.imageSelections, matching: .images) {
                Text("Open More : The Photo Picker")
                    .foregroundStyle(.green)
            }
        }
    }
}


#Preview {
    PhotoPickerView()
}
