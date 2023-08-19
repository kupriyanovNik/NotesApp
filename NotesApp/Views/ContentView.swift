//
//  ContentView.swift
//  NotesApp
//
//  Created by Никита Куприянов on 13.08.2023.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    
    @EnvironmentObject var notesViewModel: NotesViewModel
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
            Group {
                if !notes.isEmpty {
                    List {
                        ForEach(notes) { note in
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
                        .onDelete(perform: $notes.remove)
                    }
                } else {
                    Text("Tap a **+** button in toolbar.")
                }
            }
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.notesViewModel.showAddingScreen.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.blue)
                    }

                }
            }
            .sheet(isPresented: $notesViewModel.showAddingScreen) {
                AddNoteView()
                    .environmentObject(notesViewModel)
                    .interactiveDismissDisabled()
            }
        }
        .accentColor(.primary)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(NotesViewModel())
    }
}
