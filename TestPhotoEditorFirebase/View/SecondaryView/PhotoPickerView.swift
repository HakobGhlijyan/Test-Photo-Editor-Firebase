//
//  PhotoPickerView.swift
//  TestPhotoEditorFirebase
//
//  Created by Hakob Ghlijyan on 01.08.2024.
//

import SwiftUI
import PencilKit
import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI

struct PhotoPickerView: View {
    @State private var selectedItem: PhotosPickerItem?
    @State var image: UIImage?
    @State private var showCamera = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack {
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                }
                
                if let selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                }
            }
            .padding()
            
            Spacer()
            
            HStack {
                PhotosPicker("Select an image", selection: $selectedItem, matching: .images)
                    .onChange(of: selectedItem) {
                        Task {
                            if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                                image = UIImage(data: data)
                            }
                            print("Failed to load the image")
                        }
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                
                Button("Open camera") {
                    self.showCamera.toggle()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .fullScreenCover(isPresented: self.$showCamera) {
                    AccessCameraView(selectedImage: self.$selectedImage)
                }
                
            }
            .padding()
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    PhotoPickerView()
}


struct AccessCameraView: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var isPresented
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
}

// Coordinator will help to preview the selected image in the View.
class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: AccessCameraView
    
    init(picker: AccessCameraView) {
        self.picker = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        self.picker.selectedImage = selectedImage
        self.picker.isPresented.wrappedValue.dismiss()
    }
}

// To access the camera, we need to add Privacy — Camera Usage Description in Info.plist:
// text - This is app need use camera
