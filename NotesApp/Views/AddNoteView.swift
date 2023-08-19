//
//  AddNoteView.swift
//  NotesApp
//
//  Created by Никита Куприянов on 13.08.2023.
//

import SwiftUI
import RealmSwift

struct AddNoteView: View {
    
    @EnvironmentObject var vm: NewNoteViewModel
    @ObservedResults(NoteItem.self) var notes
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $vm.noteTitle)
                    TextField("Content", text: $vm.noteContent, axis: .vertical)
                } header: {
                    Text("Note information")
                }
                Section {
                    HStack {
                        CusTomColorPicker(tagColor: $vm.noteTagColor)
                            .padding()
                    }
                } header: {
                    Text("Tag")
                }

                Section {
                    Button {
                        if vm.noteTitle.count > 4 && vm.noteTitle.count < 21 {
                            let note = NoteItem()
                            note.title = vm.noteTitle
                            note.content = vm.noteContent
                            note.color = vm.noteTagColor
                            note.timestamp = .now
                            $notes.append(note)
                            dismiss()
                        } else {
                            vm.showAlert.toggle()
                        }
                    } label: {
                        Label("Add note", systemImage: "plus")
                    }
                } footer: {
                    Text("Note adding")
                }


            }
            .alert("Note title must be longer when 4 and shorter when 20 letters.", isPresented: $vm.showAlert, actions: {
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
            .environmentObject(NewNoteViewModel())
    }
}
