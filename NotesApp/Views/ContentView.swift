//
//  ContentView.swift
//  NotesApp
//
//  Created by Никита Куприянов on 13.08.2023.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @EnvironmentObject var newNoteViewModel: NewNoteViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedResults(NoteItem.self, sortDescriptor: SortDescriptor(keyPath: "timestamp", ascending: false)) var notes
    
    private var nonTodayDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }
    private var todayDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }
    private var calendar = Calendar.current
    
    var body: some View {
        NavigationView {
            ZStack {
                Group {
                    if !notes.isEmpty {
                        List {
                            ForEach(notes) { note in
                                NoteRow(note)
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
                ToolbarItem(placement: .navigationBarLeading) {
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
                }
            }
        }
        .accentColor(.primary)
    }
    @ViewBuilder func NoteRow(_ note: NoteItem) -> some View {
        var noteDate: String {
            let date = note.timestamp
            if calendar.isDateInToday(date) {
                return todayDateFormatter.string(from: date)
            } else {
                return nonTodayDateFormatter.string(from: date)
            }
        }
        NavigationLink {
            NoteView(note: note)
        } label: {
            HStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(note.color.toColor())
                    .frame(width: 3)
                VStack(alignment: .leading) {
                    Text(note.title)
                        .lineLimit(1)
                        .font(.title2)
                        .bold()
                    Text(noteDate)
                        .font(.caption)
                }
                Spacer()
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
