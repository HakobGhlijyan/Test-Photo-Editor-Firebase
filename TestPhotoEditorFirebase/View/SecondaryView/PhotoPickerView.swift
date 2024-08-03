//
//  PhotoPickerView.swift
//  TestPhotoEditorFirebase
//
//  Created by Hakob Ghlijyan on 01.08.2024.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import PencilKit
import CoreImage
import PhotosUI

struct PhotoPickerView: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showCamera = false
    
    @State private var inputImage: Image?
    @State private var scale: CGFloat = 1.0
    @State private var angle: Angle = .zero
    @State private var lastScale: CGFloat = 1.0
    @State private var lastAngle: Angle = .zero
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack {
                if let selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 300)
                        .scaleEffect(scale)
                        .rotationEffect(angle)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    scale = lastScale * value
                                }
                                .onEnded { value in
                                    lastScale = scale
                                }
                                .simultaneously(with: RotationGesture()
                                    .onChanged { value in
                                        angle = lastAngle + value
                                    }
                                    .onEnded { value in
                                        lastAngle = angle
                                    }
                                )
                        )
                    
                    
                } else {
                    GroupBox("") {
                        ContentUnavailableView (
                            "No Image",
                            systemImage: "photo",
                            description: Text("Select an image on \nphoto library or camera")
                        )
                    }
                }
            }
            .frame(height: 400)
            .frame(maxWidth: .infinity)
            .clipped()
            .padding()
            
            Spacer()
            
            HStack {
                PhotosPicker("Select an image", selection: $selectedItem, matching: .images)
                    .onChange(of: selectedItem) {
                        Task {
                            if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                                selectedImage = UIImage(data: data)
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
                        .ignoresSafeArea()
                }
                
            }
            .padding()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: selectedImage) {
            _ in loadImage()
        }
    }
    
    func loadImage() {
        guard let selectedImage = selectedImage else { return }
        inputImage = Image(uiImage: selectedImage)
        scale = 1.0
        angle = .zero
        lastScale = 1.0
        lastAngle = .zero
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
