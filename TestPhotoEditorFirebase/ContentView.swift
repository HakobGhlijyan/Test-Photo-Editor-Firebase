//
//  ContentView.swift
//  TestPhotoEditorFirebase
//
//  Created by Hakob Ghlijyan on 03.08.2024.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import PencilKit
import PhotosUI

//struct ContentView: View {
//    var body: some View {
//        Text("Hello, World!")
//    }
//}

struct ContentView: View {
    @State private var image: UIImage? = nil
    @State private var canvasView = PKCanvasView()
    @State private var text: String = ""
    @State private var fontSize: CGFloat = 20
    @State private var fontColor: Color = .black
    @State private var font: UIFont = UIFont.systemFont(ofSize: 20)
    @State private var showPhotoPicker = false
    @State private var showCameraPicker = false
    @State private var showTextField = false
    @State private var showFontPicker = false

    var body: some View {
        VStack {
            Spacer()
            
            if let image = image {
                ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                    CanvasView(canvasView: $canvasView)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.clear)
                        .allowsHitTesting(true)

                    if showTextField {
                        Text(text)
                            .font(.custom(font.fontName, size: fontSize))
                            .foregroundColor(fontColor)
                            .background(Color.white.opacity(0.7))
                            .padding()
                            .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 4)
                    }
                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .frame(width: 500)
            } else {
                Text("Select an image")
            }

            HStack {
                Button(action: {
                    showPhotoPicker = true
                }) {
                    Text("Select from Library")
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)

                Button(action: {
                    showCameraPicker = true
                }) {
                    Text("Take Photo")
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
            }

            if let _ = image {
                HStack {
                    Button(action: {
                        showTextField.toggle()
                    }) {
                        Text("Add Text")
                    }
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)

                    Button(action: saveImage) {
                        Text("Save Image")
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }

                if showTextField {
                    VStack {
                        TextField("Enter text", text: $text)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                        HStack {
                            Slider(value: $fontSize, in: 10...100, step: 1)
                            ColorPicker("Select Font Color", selection: $fontColor)
                        }
                        .padding()

                        Button(action: {
                            showFontPicker.toggle()
                        }) {
                            Text("Select Font")
                        }
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
            }
        }
        .sheet(isPresented: $showPhotoPicker) {
            PhotoPicker(image: $image)
        }
        .sheet(isPresented: $showCameraPicker) {
            CameraPicker(image: $image)
        }
        .sheet(isPresented: $showFontPicker) {
            FontPicker(selectedFont: $font)
        }
    }

    func saveImage() {
        guard let imageToSave = generateImage() else { return }
        UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
    }

    func generateImage() -> UIImage? {
        guard let baseImage = image else { return nil }

        let renderer = UIGraphicsImageRenderer(size: baseImage.size)
        return renderer.image { context in
            // Рисуем базовое изображение
            baseImage.draw(at: .zero)
            
            // Рисуем холст
            let canvasImage = canvasView.drawing.image(from: canvasView.bounds, scale: UIScreen.main.scale)
            canvasImage.draw(in: CGRect(origin: .zero, size: baseImage.size))
            
            // Рисуем текст, если он есть
            if showTextField {
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: font.withSize(fontSize),
                    .foregroundColor: UIColor(fontColor)
                ]
                let textSize = (text as NSString).size(withAttributes: attributes)
                let textRect = CGRect(x: (baseImage.size.width - textSize.width) / 2, y: (baseImage.size.height - textSize.height) / 2, width: textSize.width, height: textSize.height)
                (text as NSString).draw(in: textRect, withAttributes: attributes)
            }
        }
    }
}

struct CanvasView: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView

    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView()
        canvasView.drawingPolicy = .anyInput
        canvasView.backgroundColor = .clear // Ensure the background is transparent
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {}
}

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPicker

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider else { return }

            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        self.parent.image = image as? UIImage
                    }
                }
            }
        }
    }
}

struct CameraPicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraPicker

        init(_ parent: CameraPicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            picker.dismiss(animated: true)
        }
    }
}

struct FontPicker: View {
    @Binding var selectedFont: UIFont

    let fonts: [String] = [
        "Arial",
        "Courier New",
        "Georgia",
        "Helvetica",
        "Times New Roman",
        "Verdana"
    ]

    var body: some View {
        VStack {
            Text("Select Font")
                .font(.headline)
                .padding()
            List(fonts, id: \.self) { font in
                Button(action: {
                    selectedFont = UIFont(name: font, size: 20) ?? UIFont.systemFont(ofSize: 20)
                }) {
                    Text(font)
                        .font(Font.custom(font, size: 20))
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
