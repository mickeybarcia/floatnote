//
//  EntryViewModel.swift
//  floatnote
//
//  Created by Michaela Barcia on 4/6/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import Foundation
import UIKit

/// Data and functionality for the entry view
class EntryViewModel: ObservableObject {
    
    let entry: Entry
    let canEdit: Bool
    let defaultImage = UIImage(named: "logo")!

    @Published var date: Date
    @Published var text: String
    @Published var title: String
    @Published var form: Format
    
    @Published var images: [UIImage] = [] //[UIImage(named: "test")!, UIImage(named: "test")!, UIImage(named: "test")!]
    @Published var currentImage: UIImage?
    @Published var isLoading: Bool = false
    @Published var showPicker = false
    @Published var showGalleryFull = false
    @Published var imageIndex = 0
    
    @Published var errorMessage: String = ""
    
    private var service: FloatieService

    public init(entry: Entry=Entry.display, floatieService: FloatieService=FloatieService()) { // TO DO - dependency injection
        self.entry = entry
        self.date = entry.date
        self.text = entry.text
        self.title = entry.title
        self.form = Format.image //entry.form
        self.canEdit = entry.id == nil
        self.service = floatieService
    }
    
    /// Open gallery picker
    func openPicker() {
        showPicker = true
        errorMessage = ""
    }
    
    func setError(_ message: String) {
        self.errorMessage = message
    }
    
    func setLoading(_ isLoading: Bool) {
        self.isLoading = isLoading
    }
    
    func openFullGallery() {
        self.showGalleryFull = true
    }
    
    func closeFullGallery() {
        self.showGalleryFull = false
    }
    
    func clearText() {
        self.text = ""
    }
    
    /// Add an image to the entry and mark if the image is invalid
    func addImage() {
        showPicker = false
        if let image = currentImage {
            isLoading = true
            service.validateImage(
                image: image,
                onSuccess: { isValid in
                    if !isValid {
                        self.images.append(image)
                        self.errorMessage = "unable to convert to text.. try retaking the picture"
                    } else {
                        self.images.append(image)
                    }
                    self.isLoading = false
                },
                onFailure: {
                    self.errorMessage = "unable to convert to text.. try again later"
                    self.isLoading = false
                }
            )
            self.currentImage = nil
        }
    }
    
    /// Load the images for the entry
    func loadImages() {
        if let imageNames = entry.imageUrls,
            imageNames.count > 0,
            images.count < 1,
            let id = entry.id
        {
            self.isLoading = true
            images = [UIImage](repeating: self.defaultImage, count: imageNames.count)
            for (index, name) in imageNames.enumerated() {
                service.loadImage(
                    name: name,
                    entryId: id,
                    onSuccess: { image in
                        self.images[index] = image
                        self.isLoading = false
                    },
                    onFailure: {
                        self.errorMessage = "unable to load all images.. try again later"
                        self.isLoading = false
                    }
                )
            }
        }
    }
    
}
