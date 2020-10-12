//
//  EntryView.swift
//  floatnote
//
//  Created by Michaela Barcia on 3/19/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import SwiftUI

/// The view for editing or creating an entry
struct EntryView: View {
        
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var journal: JournalState
    @ObservedObject var entryVM: EntryViewModel
    
    @State private var titleChecker = FieldChecker()
    private let INVALID_TITLE_ERR = "invalid title.."
    
    /// Whether the fields for an entry are properly populated
    var disableSave: Bool {
        !titleChecker.valid
            || (entryVM.text.count < 1 && entryVM.form == .text)
            || (entryVM.images.count < 1 && entryVM.form == .image)
    }
    
    init(entryVM: EntryViewModel) {
        self.entryVM = entryVM
    }

    var body: some View {
        VStack {
            FloatieBanner($entryVM.errorMessage)
            Form {
                FloatieFormField(
                    label: "title",
                    value: $entryVM.title,
                    placeholder: "Dear Diary",
                    checker: $titleChecker,
                    showValidationOnEmpty: false
                ) { title in
                    title.count < 1 ? self.INVALID_TITLE_ERR : nil
                }
                FloatieDatePickerFormField(
                    label: "date",
                    date: self.$entryVM.date
                )
                FloatieFormItem(label: "format") {
                    Picker(
                        selection: self.$entryVM.form,
                        label: FloatieText(self.entryVM.form.rawValue),
                        content: {
                            FloatieText("text").tag(Format.text)
                            FloatieText("image").tag(Format.image)
                        }
                    )
                }.disabled(self.entryVM.isLoading)
                FloatieFormItem(label: "entry") {
                    if self.entryVM.form == .text {
                        FloatieTextView(text: self.$entryVM.text)
                            .frame(height: 500)
                            .onTapGesture {
                                self.entryVM.clearText()
                            }
                    } else {
                        EntryImagesView(entryVM: self.entryVM).frame(height: 300)
                    }
                }
            }
        }
        .sheet(isPresented: $entryVM.showPicker, onDismiss: entryVM.addImage) {
            FloatieImagePicker(image: self.$entryVM.currentImage)
        }
        .onAppear {
            self.entryVM.loadImages()
        }
        .onDisappear {
            self.entryVM.setError("")
        }
        .navigationBarTitle(Text(entryVM.title.count > 0 ? entryVM.title : "Dear Diary"))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: FloatieBarButton("back", dismiss),
            trailing: FloatieBarButton("save", saveEntry)
                        .disabled(self.disableSave || self.entryVM.isLoading)
        )
    }
    
    /// Saves the entry and the images if needed
    private func saveEntry() {  // TODO move logic to VM
        self.entryVM.setLoading(true)
        journal.saveEntry(
            entry: Entry(
                id: entryVM.entry.id,
                title: entryVM.title.trimmingCharacters(in: .whitespaces),
                text: entryVM.text.trimmingCharacters(in: .whitespaces),
                form: entryVM.form,
                date: entryVM.date
            ),
            onSuccess: { entry in
                if
                    self.entryVM.form == .image,
                    self.entryVM.canEdit,
                    let entryId = entry.id,
                    self.entryVM.images.count > 0
                {
                    self.entryVM.setLoading(true)
                    self.journal.saveImages(
                        images: self.entryVM.images,
                        entryId: entryId,
                        onSuccess: {
                            self.entryVM.setLoading(false)
                            self.dismiss()
                        },
                        onFailure: { errorMessage in
                            self.entryVM.setError(errorMessage)
                            self.entryVM.setLoading(false)
                        }
                    )
                } else {
                    self.entryVM.setLoading(false)
                    self.dismiss()
                }
            },
            onFailure: { errorMessage in
                self.entryVM.setError(errorMessage)
                self.entryVM.setLoading(false)
            }
        )
    }
    
    private func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
}

struct EntryView_Previews: PreviewProvider {
    static var previews: some View {
        EntryView(entryVM: EntryViewModel()).environmentObject(JournalState())
    }
}
