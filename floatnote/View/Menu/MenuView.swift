//
//  MenuView.swift
//  floatnote
//
//  Created by Michaela Barcia on 3/28/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import SwiftUI

/// The main menu
struct MenuView: View {
    
    @EnvironmentObject private var auth: AuthState
    @State private var selection: Int? = nil
    @State private var isLoading = false
    @State private var errorMessage: String = "unable to load profile details.. try again later"

    var body: some View {
        
        var accountButtons: some View {
            if let user = auth.user {
                return AnyView(
                    Group {
                        NavigationLink(
                            destination: ProfileView(user: user).environmentObject(auth),
                            tag: 1,
                            selection: $selection
                        ) {
                            FloatieButton("profile", { self.selection = 1 })
                        }
                        NavigationLink(
                            destination: AccountView(user: user).environmentObject(auth),
                            tag: 2,
                            selection: $selection
                        ) {
                            FloatieButton("account", { self.selection = 2 })
                        }
                        NavigationLink(
                            destination: SettingsView(),
                            tag: 5,
                            selection: $selection
                        ) {
                            FloatieButton("settings", { self.selection = 5 })
                        }
                    }
                )
            }
            return AnyView(
                FloatieBanner(self.$errorMessage)  // .fixedSize(horizontal: false, vertical: true)
            )
        }
        
        return ZStack {
            Color.floatieDarkBlue.edgesIgnoringSafeArea(.all)
            VStack {
                accountButtons
                NavigationLink(
                    destination: AboutView(),
                    tag: 3,
                    selection: $selection
                ) {
                    FloatieButton("about", { self.selection = 3 })
                }
                NavigationLink(
                    destination: HelpView().environmentObject(auth),
                    tag: 4,
                    selection: $selection
                ) {
                    FloatieButton("help", { self.selection = 4 })
                }
                FloatieButton("logout", self.logout)
            }
        }.navigationBarTitle("MENU")
        
    }
    
    func logout() {
        self.isLoading = true
        self.auth.logout()
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
             self.isLoading = false
        }
    }
    
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView().environmentObject(AuthState())
    }
}
