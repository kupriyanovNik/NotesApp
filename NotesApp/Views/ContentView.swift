//
//  ContentView.swift
//  NotesApp
//
//  Created by Никита Куприянов on 13.08.2023.
//

import SwiftUI
import RealmSwift
import Firebase

struct ContentView: View {
    
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @EnvironmentObject var newNoteViewModel: NewNoteViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedResults(NoteItem.self, sortDescriptor: SortDescriptor(keyPath: "timestamp", ascending: false)) var notes
    
    var manager = FirebaseManager.shared
    
    var body: some View {
        NavigationView {
            ZStack {
                Group {
                    if !notes.isEmpty {
                        List {
                            ForEach(notes) { note in
                                NoteRow(note: note)
                            }
                            .onDelete(perform: $notes.remove)
                        }
                    } else {
                        ZStack {
                            (colorScheme == .light ? Color(.secondarySystemBackground) : Color.black)
                                .ignoresSafeArea()
                            Text("Tap a **+** button in toolbar.")
                        }
                    }
                }
                .sheet(isPresented: $navigationViewModel.showAddingScreenModal) {
                    AddNoteView(isModalPresentation: true)
                        .environmentObject(newNoteViewModel)
                        .environmentObject(settingsViewModel)
                        .interactiveDismissDisabled()
                }
                .sheet(isPresented: $navigationViewModel.showSettingsScreenModal) {
                    SettingsView(isModalPresentation: true)
                        .environmentObject(settingsViewModel)
                        .interactiveDismissDisabled()
                }
                NavigationLink(isActive: $navigationViewModel.showSettingsScreen) {
                    SettingsView(isModalPresentation: false)
                        .environmentObject(settingsViewModel)
                } label: { }
                    .frame(height: 0)
                    .opacity(0)
                NavigationLink(isActive: $navigationViewModel.showAddingScreen) {
                    AddNoteView(isModalPresentation: false)
                        .environmentObject(newNoteViewModel)
                        .environmentObject(settingsViewModel)
                } label: { }
                    .frame(height: 0)
                    .opacity(0)
            }
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if settingsViewModel.showAddingViewModally {
                            self.navigationViewModel.showAddingScreenModal.toggle()
                        } else {
                            self.navigationViewModel.showAddingScreen.toggle()
                        }
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(settingsViewModel.appAccentColor.toColor())
                    }
                }
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        if settingsViewModel.showSettingsViewModally {
                            self.navigationViewModel.showSettingsScreenModal.toggle()
                        } else {
                            self.navigationViewModel.showSettingsScreen.toggle()
                        }
                    } label: {
                        Image(systemName: "gear")
                            .foregroundColor(settingsViewModel.appAccentColor.toColor())
                    }
                    Button {
                        fetchAllNotes()
                    } label: {
                        Image(systemName: "arrow.turn.left.down")
                            .foregroundColor(settingsViewModel.appAccentColor.toColor())
                    }
                }
            }
        }
        .accentColor(.primary)
    }
    private func fetchAllNotes() {
        manager
            .firestore
            .collection("notes")
            .getDocuments { snapshot, error in
                if let error {
                    print(error)
                    return
                }
                
                var insideNotes = Array(self.notes).filter { !$0.isPersistedFB }
                
                snapshot?.documents.forEach { doc in
                    let data = doc.data()
                    if data["fromUID"] as? String ?? "default" == manager.auth.currentUser?.uid {
                        let noteTitle = data["noteTitle"] ?? "default noteTitle"
                        let noteContent = data["noteContent"] ?? "default noteContent"
                        let noteColor = data["noteColor"] ?? "default noteColor"
                        let noteTimestamp = data["timestamp"] as? Timestamp ?? .init(date: .now)
                        let newNote = NoteItem()
                        newNote.title = noteTitle as! String
                        newNote.content = noteContent as! String
                        newNote.color = noteColor as! String
                        newNote.timestamp = noteTimestamp.dateValue()
                        newNote.noteUUID = doc.documentID
                        newNote.isPersistedFB = true
                        insideNotes.append(newNote)
                    }
                }
                
                for note in self.notes {
                    if note.isPersistedFB {
                        $notes.remove(note)
                    }
                }
                
                for item in insideNotes {
                    $notes.append(item)
                }
                
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(NavigationViewModel())
            .environmentObject(NewNoteViewModel())
            .environmentObject(SettingsViewModel())
    }
}


extension View {
  func hideKeyboard() {
    let resign = #selector(UIResponder.resignFirstResponder)
    UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
  }
}
