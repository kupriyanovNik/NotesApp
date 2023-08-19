//
//  AddNoteView.swift
//  NotesApp
//
//  Created by Никита Куприянов on 13.08.2023.
//

import SwiftUI
import RealmSwift

struct AddNoteView: View {
    
    @EnvironmentObject var notesViewModel: NotesViewModel
    @ObservedResults(NoteItem.self) var notes
    @Environment(\.dismiss) var dismiss
    
    @State private var showAlert: Bool = false
    @State private var noteTitle: String = ""
    @State private var noteContent: String = ""
    @State private var noteTagColor: String = "red"
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $noteTitle)
                    TextField("Content", text: $noteContent, axis: .vertical)
                } header: {
                    Text("Note information")
                }
                Section {
                    HStack {
                        CusTomColorPicker(tagColor: $noteTagColor)
                            .padding()
                    }
                } header: {
                    Text("Tag")
                }

                Section {
                    Button {
                        if noteTitle.count > 4 && noteTitle.count < 21 {
                            let note = NoteItem()
                            note.title = noteTitle
                            note.content = noteContent
                            note.color = noteTagColor
                            note.timestamp = .now
                            $notes.append(note)
                            dismiss()
                        } else {
                            showAlert.toggle()
                        }
                    } label: {
                        Label("Add note", systemImage: "plus")
                    }
                } footer: {
                    Text("Note adding")
                }


            }
            .alert("Note title must be longer when 4 and shorter when 20 letters.", isPresented: $showAlert, actions: {
                Button("ok", role: .cancel) {
                    
                }
            })
            .navigationTitle("New note")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct AddNoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddNoteView()
            .environmentObject(NotesViewModel())
    }
}
