//
//  MainTabView.swift
//  floatnote
//
//  Created by Michaela Barcia on 3/18/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import SwiftUI

/// The landing page that either shows the dashboard, journal, the nav main menu, or a verification message
struct MainTabView: View {
    
    private let width = UIScreen.main.bounds.width - 100
    
    @EnvironmentObject private var journal: JournalState
    @EnvironmentObject private var auth: AuthState
    
    /// The current tab defaults to journal
    @State private var selectedTab: Tab = .journal
    
    /// Whether to overlay the menu view
    @State private var showMenu = false
    
    var body: some View {
        let menuButton = Button(
            action: {
                withAnimation {
                    self.showMenu.toggle()
                }
            }
        ) {
            Image("menu").modifier(FloatieIconButtonStyle())
        }
        
        var menuView: some View {
            NavigationView {
                    MenuView()
                        .environmentObject(self.auth)
                        .navigationBarItems(trailing: menuButton)
                        .transition(.slide)
                        .gesture(
                            DragGesture().onEnded {
                                if $0.translation.width < -100 {
                                    withAnimation {
                                        self.showMenu = false
                                    }
                                }
                            }
                        )
            }.transition(.slide)
        }
        
        var addEntryButton: some View {
            NavigationLink(destination: EntryView(entryVM: EntryViewModel())
                    .environmentObject(self.journal)
            ) {
                Image(systemName: "plus").modifier(FloatieIconButtonStyle())
            }
        }
        
        var tabView: some View {
           ZStack {
                TabView(selection: self.$selectedTab) {
                        NavigationView {
                            JournalView()
                                .environmentObject(self.journal)
                                .navigationBarItems(leading: menuButton, trailing: addEntryButton)
                        }
                        .tag(Tab.journal)
                        .tabItem {
                            Image("journal")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color.floatieDarkBlue)
                            FloatieText("JOURNAL").foregroundColor(Color.floatieDarkBlue)
                        }
                        NavigationView {
                            DashboardView()
                                .environmentObject(self.journal)
                                .navigationBarItems(leading: menuButton)
                        }
                        .tag(Tab.dashboard)
                        .tabItem {
                            Image("dashboard")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color.floatieDarkBlue)
                            FloatieText("DASHBOARD").foregroundColor(Color.floatieDarkBlue)
                        }
                }.disabled(self.showMenu)
            }
        }
        
        var emailVerifyView: some View {
            NavigationView {
                VerifyEmailView()
                    .environmentObject(self.auth)
                    .navigationBarItems(leading: menuButton)
            }
        }
        
        var mainView: some View {
            if let user = auth.user, user.isVerified {  // user is verified
                return AnyView(tabView)
            } else if auth.user == nil {
                 return AnyView(tabView)
            } else {  // user is not verified
                return AnyView(emailVerifyView)
            }
        }
        
        return ZStack(alignment: .leading) {
            mainView
            if self.showMenu {
                menuView
            }
        }.onAppear {
            self.journal.getEntries()
        }
        
    }
    
}

extension MainTabView {
    
    /// The two tabs dashboard and journal
    enum Tab: Hashable {
        case dashboard
        case journal
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(JournalState())
            .environmentObject(AuthState())
    }
}
