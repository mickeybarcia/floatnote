//
//  HomeView.swift
//  floatnote
//
//  Created by Michaela Barcia on 3/1/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import SwiftUI

/// The page for logged out or new users
struct WelcomeView: View {
    
    @EnvironmentObject private var auth: AuthState
    @State private var selection: Int? = nil
    @State private var navHidden = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.floatieDarkBlue.edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    FloatieLogo.BIG_LOGO
                    FloatieTitle("float note")
                    Spacer()
                    NavigationLink(
                        destination: SignupView().environmentObject(auth),
                        tag: 1,
                        selection: $selection
                    ) {
                        FloatieButton("signup", { self.selection = 1 })
                    }
                    NavigationLink(
                        destination: LoginView().environmentObject(auth),
                        tag: 2,
                        selection: $selection
                    ) {
                        FloatieButton("login", { self.selection = 2 })
                            .padding(.bottom, 20)
                    }
                }
            }
            .onAppear { self.navHidden = true }
            .onDisappear() { self.navHidden = false }
            .navigationBarTitle("")
            .navigationBarHidden(navHidden)
            
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView().environmentObject(AuthState())
    }
}
