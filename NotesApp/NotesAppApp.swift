//
//  NotesAppApp.swift
//  NotesApp
//
//  Created by Никита Куприянов on 13.08.2023.
//

import SwiftUI

@main
struct NotesAppApp: App {
    @StateObject private var notesViewModel = NotesViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(notesViewModel)
        }
    }
}
