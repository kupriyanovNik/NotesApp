//
//  NotesAppApp.swift
//  NotesApp
//
//  Created by Никита Куприянов on 13.08.2023.
//

import SwiftUI
import Firebase

@main
struct NotesAppApp: App {
    @StateObject private var navigationViewModel = NavigationViewModel()
    @StateObject private var newNoteViewModel = NewNoteViewModel()
    @StateObject private var settingsViewModel = SettingsViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navigationViewModel)
                .environmentObject(newNoteViewModel)
                .environmentObject(settingsViewModel)
        }
    }
}
