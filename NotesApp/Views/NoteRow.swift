//
//  NoteRow.swift
//  NotesApp
//
//  Created by Никита Куприянов on 20.08.2023.
//

import SwiftUI
import RealmSwift

struct NoteRow: View {
    @ObservedRealmObject var note: NoteItem

    var nonTodayDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }
    var todayDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }
    var calendar = Calendar.current
    var noteDate: String {
        let date = note.timestamp
        if calendar.isDateInToday(date) {
            return todayDateFormatter.string(from: date)
        } else {
            return nonTodayDateFormatter.string(from: date)
        }
    }
    
    var manager = FirebaseManager.shared
    
    var body: some View {
        if note.isPersistedFB {
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
            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                Button {
                    removeFromFirebase()
                } label: {
                    Label("", systemImage: "antenna.radiowaves.left.and.right.slash")
                }
                .tint(.indigo)
            }
            
        } else {
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
    private func removeFromFirebase() {
        manager
            .firestore
            .collection("notes")
            .document(note.noteUUID)
            .delete()
        $note.isPersistedFB.wrappedValue = false
    }
}

struct NoteRow_Previews: PreviewProvider {
    static var previews: some View {
        NoteRow(note: .init()) 
    }
}
