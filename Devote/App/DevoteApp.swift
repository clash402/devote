//
//  DevoteApp.swift
//  Devote
//
//  Created by Josh Courtney on 6/21/21.
//

import SwiftUI

@main
struct DevoteApp: App {
    @AppStorage("isDarkMode") var isDarkMode = false
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
