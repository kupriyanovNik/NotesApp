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
    @ObservedRealmObject var note: NoteItem
    
    @State private var newNoteTitle: String = ""
    @State private var isEditingTitle: Bool = false
    @State private var showAlert: Bool = false
    @State private var bgColor: Color? = nil
    @State private var colorScale: Bool = false
    
    var body: some View {
        ZStack {
            (bgColor == nil ? (colorScheme == .dark ? Color.black : Color(.secondarySystemBackground)) : bgColor)
                .ignoresSafeArea()
            VStack {
                if isEditingTitle {
                    VStack {
                        TextField(note.title, text: $newNoteTitle, axis: .vertical)
                            .bold()
                            .font(.title3)
                            .onSubmit {
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
                        CusTomColorPicker(tagColor: $note.color)
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
                            .scaleEffect(colorScale ? 1.5 : 1)
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
        .alert("Note title must be longer when 4 and shorter when 20 letters.", isPresented: $showAlert, actions: {
            Button("ok", role: .cancel) {
                
            }
        })
    }
    private func changeBackgroundColor() {
        withAnimation(.linear(duration: 0.2)) {
            bgColor = note.color.toColor()
        }
        withAnimation(.linear(duration: 0.2).delay(1)) {
            bgColor = nil
        }
        withAnimation(.linear(duration: 0.1).delay(1.4)) {
            self.colorScale = true
        }
        withAnimation(.linear(duration: 0.1).delay(1.55)) {
            self.colorScale = false
        }
    }
}

struct NoteView_Previews: PreviewProvider {
    static var previews: some View {
        NoteView(note: .init())
    }
}


