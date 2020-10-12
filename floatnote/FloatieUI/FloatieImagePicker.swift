//
//  FloatieImagePicker.swift
//  floatnote
//
//  Created by Michaela Barcia on 3/22/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import SwiftUI

/// Image Picker for camera
struct FloatieImagePicker: UIViewControllerRepresentable {

    /// Presentation to dismiss
    @Environment(\.presentationMode) var presentationMode

    /// The selected image
    @Binding var image: UIImage?

    /// Coordinator for image picker
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        /// Presentation to dismiss
        @Binding var presentationMode: PresentationMode

        /// The selected image
        @Binding var image: UIImage?

        init(presentationMode: Binding<PresentationMode>, image: Binding<UIImage?>) {
            _presentationMode = presentationMode
            _image = image
        }

        /// Dismiss the picker when the image is selected
        /// - Parameters:
        ///   - picker: picker controller
        ///   - info: info to get selected image
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            presentationMode.dismiss()
        }

        /// Dismiss the picker when the selection is cancelled
        /// - Parameter picker: picker controller
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.dismiss()
        }

    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentationMode: presentationMode, image: $image)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<FloatieImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        if FloatieEnvironment.CONFIGURATION == "Debug" {
            picker.sourceType =  .photoLibrary
        } else {
            picker.sourceType =  .camera
        }
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<FloatieImagePicker>) {
    }

}

// reference: https://stackoverflow.com/questions/56515871/how-to-open-the-imagepicker-in-swiftui
