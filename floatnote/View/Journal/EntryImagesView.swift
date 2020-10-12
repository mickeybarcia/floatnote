//
//  EntryFormatView.swift
//  floatnote
//
//  Created by Michaela Barcia on 4/8/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import SwiftUI

/// Displays the images for the entry and allows more to be added
struct EntryImagesView: View {

    @ObservedObject var entryVM: EntryViewModel
    
    private let ADD_IMAGE_INFO = "click + to add an image\n from your camera"
                
    var body: some View {
        var pagingView: some View {
            FloatiePagingView(
                index: $entryVM.imageIndex.animation(),
                maxIndex: self.entryVM.images.count - 1
            ) {
                ForEach(self.entryVM.images, id: \.self) { image in
                    HStack {
                        Spacer()
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                        //.frame(height: 400)
                        Spacer()
                    }
                }.onTapGesture {
                    self.entryVM.openFullGallery()
                }
            }
        }
        
        return VStack {
            if self.entryVM.canEdit && !self.entryVM.isLoading {
                HStack {
                    if self.entryVM.images.count > 0 {
                        Image(systemName: "trash")
                            .modifier(FloatieIconButtonStyle(isEnabled: !self.entryVM.isLoading))
                            .onTapGesture {
                                self.entryVM.images.remove(
                                    at: self.$entryVM.imageIndex.animation().wrappedValue
                                ) // TODO - bug handling
                            }
                    }
                    Spacer()
                    Image(systemName: "plus")
                        .modifier(FloatieIconButtonStyle(isEnabled: !self.entryVM.isLoading))
                        .onTapGesture {
                            self.entryVM.openPicker()
                        }
                }
            }
            Spacer()
            VStack {
                if self.entryVM.isLoading {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            FloatieLoader()
                            Spacer()
                        }
                        Spacer()
                    }
                } else if self.entryVM.images.count > 0 {
                    pagingView
                } else {
                    FloatieMessageText(self.ADD_IMAGE_INFO)
                        .padding()
                        .multilineTextAlignment(.center)
                    Image(uiImage: self.entryVM.defaultImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                    Spacer()
                }
            }
        }.sheet(isPresented: $entryVM.showGalleryFull, onDismiss: entryVM.closeFullGallery) {
            pagingView
        }
    }

}

struct EntryImagesView_Previews: PreviewProvider {
        static var previews: some View {
        EntryImagesView(entryVM: EntryViewModel())
    }
}
