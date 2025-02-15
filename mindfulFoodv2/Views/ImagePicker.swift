//
//  ImagePicker.swift
//  mindfulFoodv2
//
//  Created by Charlotte Woodrum on 2/16/25.
//

import Photos
import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    var food: FetchedResults<Food>.Element
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self, food: food)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        let food: FetchedResults<Food>.Element
        
        init(_ parent: ImagePicker, food: FetchedResults<Food>.Element) {
            self.parent = parent
            self.food = food
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }
            
            provider.loadObject(ofClass: UIImage.self) { image, _ in
                DispatchQueue.main.async {
                    self.parent.selectedImage = image as? UIImage
                    if let image = self.parent.selectedImage {
                        if let imageData = image.jpegData(compressionQuality: 1.0) {
                            self.food.image = imageData
                            try? self.food.managedObjectContext?.save()
                        }
                    }
                }
                
            }
        }
        
        
    }
}
