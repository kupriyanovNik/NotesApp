//
//  NotesViewModel.swift
//  NotesApp
//
//  Created by Никита Куприянов on 13.08.2023.
//

import SwiftUI

class NavigationViewModel: ObservableObject {
    
    @Published var showAddingScreen: Bool = false
    @Published var showAddingScreenModal: Bool = false
    
    @Published var showSettingsScreen: Bool = false
    @Published var showSettingsScreenModal: Bool = false
}

