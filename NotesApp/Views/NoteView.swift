//
//  NoteView.swift
//  NotesApp
//
//  Created by Никита Куприянов on 13.08.2023.
//

import SwiftUI
import RealmSwift

struct NoteView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    @ObservedRealmObject var note: NoteItem
    
    @State private var newNoteTitle: String = ""
    @State private var isEditingTitle: Bool = false
    @State private var showAlert: Bool = false
    @State private var bgColor: Color? = nil
    @State private var errorMessage: String? = nil
    
    var manager = FirebaseManager.shared
    
    var body: some View {
        ZStack {
            (bgColor == nil ? (colorScheme == .dark ? Color.black : Color(.secondarySystemBackground)) : bgColor)
                .ignoresSafeArea()
            VStack {
                if isEditingTitle {
                    VStack {
                        TextField(note.title, text: $newNoteTitle)
                            .bold()
                            .font(.title3)
                            .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidEndEditingNotification)) { _ in
                                let newTitleLength = newNoteTitle.replacingOccurrences(of: " ", with: "").count
                                if newTitleLength > 4 && newTitleLength < 21 {
                                    $note.title.wrappedValue = newNoteTitle
                                    withAnimation(.spring()) {
                                        self.isEditingTitle.toggle()
                                    }
                                    changeBackgroundColor()
                                } else {
                                    showAlert.toggle()
                                }
                            }
                        Divider()
                        CustomColorPicker(tagColor: $note.color)
                    }
                    .padding()
                    .background(colorScheme == .dark ? Color(.secondarySystemBackground) : .white)
                    .cornerRadius(10)
                    .transition(.move(edge: .top).combined(with: .opacity).combined(with: .scale))
                }
                TextField("Content of note", text: $note.content, axis: .vertical)
                    .padding()
                    .background(colorScheme == .dark ? Color(.secondarySystemBackground) : .white)
                    .cornerRadius(10)
                Spacer()
            }
            .padding(.horizontal)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    if !settingsViewModel.isAuth {
                        HStack(spacing: 10) {
                            Text(newNoteTitle)
                                .bold()
                                .font(.title3)
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        self.isEditingTitle.toggle()
                                    }
                                }
                            Circle()
                                .fill(note.color.toColor())
                                .frame(width: 10, height: 10)
                        }
                    } else {
                        Menu {
                            Button(isEditingTitle ? "Hide" : "Expand") {
                                withAnimation(.spring()) {
                                    self.isEditingTitle.toggle()
                                }
                            }
                            Button("Publish to Firebase") {
                                let noteData = [
                                    "fromUID" : manager.auth.currentUser?.uid ?? "defaultID",
                                    "noteTitle" : note.title,
                                    "noteContent" : note.content,
                                    "noteColor" : note.color,
                                    "timestamp" : note.timestamp as Date
                                ] as [String : Any]
                                manager
                                    .firestore
                                    .collection("notes")
                                    .document(note.noteUUID)
                                    .setData(noteData) { error in
                                        if let error {
                                            withAnimation {
                                                self.errorMessage = error.localizedDescription
                                                self.showAlert = true
                                                return
                                            }
                                        }
                                        self.errorMessage = nil
                                    }
                            }
                        } label: {
                            HStack(spacing: 10) {
                                Text(newNoteTitle)
                                    .bold()
                                    .font(.title3)
                                    .onTapGesture {
                                        withAnimation(.spring()) {
                                            self.isEditingTitle.toggle()
                                        }
                                    }
                                Circle()
                                    .fill(note.color.toColor())
                                    .frame(width: 10, height: 10)
                            }
                        }

                    }
                }
            }
            .onAppear {
                self.newNoteTitle = note.title
            }
            .onChange(of: note.color) { newValue in
                changeBackgroundColor()
            }
        }
        .alert(errorMessage == nil ? "Note title must be longer when 4 and shorter when 20 letters." : errorMessage!, isPresented: $showAlert, actions: {
            Button("ok", role: .cancel) {
                
            }
        })
    }
    private func changeBackgroundColor() {
        if settingsViewModel.shouldShowBackgroundAnimation {
            withAnimation(.linear(duration: 0.2)) {
                bgColor = note.color.toColor()
            }
            withAnimation(.linear(duration: 0.2).delay(1)) {
                bgColor = nil
            }
        }
    }
}

struct NoteView_Previews: PreviewProvider {
    static var previews: some View {
        NoteView(note: .init())
            .environmentObject(SettingsViewModel())
    }
}


