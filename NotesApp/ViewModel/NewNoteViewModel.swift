//
//  NewNoteViewModel.swift
//  NotesApp
//
//  Created by Никита Куприянов on 19.08.2023.
//

import SwiftUI

class NewNoteViewModel: ObservableObject {
    @Published var showAlert: Bool = false
    @Published var noteTitle: String = ""
    @Published var noteContent: String = ""
    @Published var noteTagColor: String = "red"
    
    func clear() {
        self.noteTitle = ""
        self.noteContent = ""
        self.noteTagColor = "red"
    }
}
