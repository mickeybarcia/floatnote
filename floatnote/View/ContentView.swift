//
//  ContentView.swift
//  floatnote
//
//  Created by Michaela Barcia on 3/18/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import SwiftUI

/// The entry point to the app, brings you to the main view if logged in else the welcome view
struct ContentView: View {
    
    @EnvironmentObject private var auth: AuthState
    @EnvironmentObject private var journal: JournalState
    
    init() {  // define global app appearance
        UINavigationBar.appearance().scrollEdgeAppearance = FloatieNavBar.appearance
        UINavigationBar.appearance().standardAppearance = FloatieNavBar.appearance
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().separatorStyle = .none
    }

    var body: some View {
        ZStack {
            if auth.isLoggedIn == false {
                WelcomeView().environmentObject(auth)
            } else if auth.isNewUser {
                HelpView().environmentObject(auth)
            } else {
                MainTabView()
                    .environmentObject(journal)
                    .environmentObject(auth)
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthState())
            .environmentObject(JournalState())
    }
}
