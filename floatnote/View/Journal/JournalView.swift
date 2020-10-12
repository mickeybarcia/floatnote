//
//  JournalView.swift
//  floatnote
//
//  Created by Michaela Barcia on 3/18/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import SwiftUI

/// The list of journal entries
struct JournalView: View {
    
    @EnvironmentObject private var journal: JournalState
    @State private var selection: Int? = nil
    @State private var currentEntryDate: Date = Date()

    init() {
        UIScrollView.appearance().bounces = false
    }

    var body: some View {
        ZStack {
            Color.floatieDarkBlue.edgesIgnoringSafeArea(.all)
            VStack {
                NavigationLink(
                    destination: JournalFilterView()
                                    .environmentObject(self.journal)
                                    .background(Color.white),
                    tag: 1,
                    selection: $selection
                ) {
                    HStack {
                        Spacer()
                        Button(action: self.applyFilter) {
                            Image("filter")
                                .resizable()
                                .scaledToFit()
                                .padding(.top, 10)
                                .padding(.trailing, 10)
                                .foregroundColor(Color.white)
                                .frame(width: 40)
                        }
                    }
                }
                FloatieBanner($journal.errorMessage, infoMessage: $journal.infoMessage, addHeaderSpace: false)
                List {
                    ForEach(journal.entries) { entry in
                        VStack {
                            NavigationLink(
                                destination: EntryView(entryVM: EntryViewModel(entry: entry))
                                                .environmentObject(self.journal)
                            ) {
                                JournalRowView(entry: entry)
                            }
                            if self.journal.entries.isLastItem(entry) {
                                Divider().frame(height: 1)
                                if !self.journal.endOfJournal {
                                    FloatieLoader()
                                }
                                if !self.journal.isLoading {
                                    Image("logo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50)
                                        .padding(5)
                                }
                            }
                        }.onAppear {
                            self.listItemAppears(entry)
                            self.currentEntryDate = entry.date
                        }
                    }
                    .onDelete(perform: delete)
                    .listRowBackground(Color.floatieDarkBlue)
                }
                FloatieMessageText(
                    DateUtil.getShortEntryDisplayStringFromDate(date: self.currentEntryDate),
                    size: 15
                )
            }
            .background(Color.floatieDarkBlue)
            .navigationBarTitle(Text("JOURNAL"))
        }
    }
    
    /// Delete a journal entry
    /// - Parameter offsets: the table row index
    private func delete(at offsets: IndexSet) {
        if let index = offsets.first {
            journal.deleteEntry(
                index: index,
                onFailure: { errorMessage in
                    self.journal.errorMessage = errorMessage
                    self.journal.infoMessage = ""
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
                        // show error message for 5 seconds
                        self.journal.errorMessage = ""
                    }
                }
            )
        }
    }
    
    /// Reset the error and open apply filter view
    private func applyFilter() {
        self.journal.errorMessage = ""
        self.journal.infoMessage = ""
        self.selection = 1
    }
    
}

extension RandomAccessCollection where Self.Element: Identifiable {
    
    /// Determine if you are scrolled to the bottom
    /// - Parameter item: the list item
    /// - Returns: whether you are at the bottom
    func isLastItem<Entry: Identifiable>(_ item: Entry) -> Bool {
        guard !isEmpty else {
            return false
        }
        guard let itemIndex = firstIndex(where: { $0.id.hashValue == item.id.hashValue }) else {
            return false
        }
        let distance = self.distance(from: itemIndex, to: endIndex)
        return distance == 1
    }
    
}

extension JournalView {
    
    /// Checks for being scrolled at the bottom, if there are potentially more entries, they will be loaded
    /// - Parameter item: the entry appearing
    private func listItemAppears<Entry: Identifiable>(_ item: Entry) {
        if self.journal.entries.isLastItem(item) && !self.journal.endOfJournal { 
            self.journal.getEntries() 
        }
    }
    
}

struct JournalView_Previews: PreviewProvider {
    static var previews: some View {
        JournalView().environmentObject(JournalState())
    }
}
