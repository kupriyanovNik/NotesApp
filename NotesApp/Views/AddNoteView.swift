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
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    @ObservedResults(NoteItem.self) var notes
    @Environment(\.dismiss) var dismiss
    
    var isModalPresentation: Bool
    
    var body: some View {
        if isModalPresentation {
            NavigationView {
                mainAddingView
                    .toolbar {
                        ToolbarItem(placement: settingsViewModel.isLeftAlignmentOfCancelButton ? .navigationBarLeading : .navigationBarTrailing) {
                            Button {
                                if settingsViewModel.alwaysClearField {
                                    vm.clear()
                                }
                                dismiss()
                            } label: {
                                Text("Cancel")
                                    .foregroundColor(settingsViewModel.appAccentColor.toColor())
                            }
                        }
                    }
            }
        } else {
            mainAddingView
        }
    }
    private var mainAddingView: some View {
        Form {
            Section {
                TextField("Title", text: $vm.noteTitle)
                TextField("Content", text: $vm.noteContent, axis: .vertical)
            } header: {
                Text("Note information")
            }
            Section {
                ScrollView(.horizontal, showsIndicators: false) {
                    CustomColorPicker(tagColor: $vm.noteTagColor)
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
                        note.noteUUID = UUID().uuidString
                        note.isPersistedFB = false 
                        $notes.append(note)
                        vm.clear()
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
            Button("clear", role: .destructive) {
                vm.clear()
            }
        })
        .navigationBarTitleDisplayMode(settingsViewModel.alwaysInlineTitle ? .inline : .automatic)
        .navigationTitle("New note")
    }
}

struct AddNoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddNoteView(isModalPresentation: true)
            .environmentObject(NewNoteViewModel())
            .environmentObject(SettingsViewModel())
    }
}
