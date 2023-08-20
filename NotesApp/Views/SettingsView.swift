//
//  SettingsView.swift
//  NotesApp
//
//  Created by Никита Куприянов on 19.08.2023.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    var isModalPresentation: Bool
    
    var body: some View {
        if isModalPresentation {
            NavigationView {
                mainSettingsView
                    .toolbar {
                        ToolbarItem(placement: settingsViewModel.isLeftAlignmentOfCancelButton ? .navigationBarLeading : .navigationBarTrailing) {
                            Button {
                                dismiss()
                            } label: {
                                Text("Cancel")
                                    .foregroundColor(settingsViewModel.appAccentColor.toColor())
                            }
                            
                        }
                    }
            }
            .accentColor(.primary)
        } else {
            mainSettingsView
            
        }
    }
    private var mainSettingsView: some View {
        Form {
            Section {
                Toggle("Show settings screen modally", isOn: $settingsViewModel.showSettingsViewModally)
                Toggle("Show adding screen modally", isOn: $settingsViewModel.showAddingViewModally)
                Picker("\"Cancel\" alignment", selection: $settingsViewModel.isLeftAlignmentOfCancelButton) {
                    Text("Left")
                        .tag(true)
                    Text("Right")
                        .tag(false)
                }
            } header: {
                Text("Navigation")
            }
            Section {
                Toggle("Always clear adding fields", isOn: $settingsViewModel.alwaysClearField)
            } header: {
                Text("Logic")
            }

            Section {
                Toggle("Always inline title", isOn: $settingsViewModel.alwaysInlineTitle)
                Toggle("Show bg. animation", isOn: $settingsViewModel.shouldShowBackgroundAnimation)
                VStack(alignment: .leading) {
                    Text("Tint color")
                    ScrollView(.horizontal, showsIndicators: false) {
                        CustomColorPicker(tagColor: $settingsViewModel.appAccentColor)
                            .padding(5)
                    }
                }
            } header: {
                Text("Interface")
            }
            if settingsViewModel.isAuth {
                Section {
                    Label(FirebaseManager.shared.auth.currentUser?.email ?? "default email", systemImage: "person")
                    Button {
                        do {
                            try FirebaseManager.shared.auth.signOut()
                            settingsViewModel.isAuth = false
                        } catch {
                            print(error.localizedDescription)
                        }
                    } label: {
                        Label("Log Out", systemImage: "person.fill.xmark")
                            .foregroundColor(.primary)
                    }
                } header: {
                    Text("Firebase")
                }
            } else {
                Section {
                    NavigationLink {
                        AuthView()
                            .environmentObject(settingsViewModel)
                    } label: {
                        Label("Authentication", systemImage: "person.fill.checkmark")
                            .foregroundColor(.primary)
                    }
                } header: {
                    Text("Firebase")
                }
            }
        }
        .navigationBarTitleDisplayMode(settingsViewModel.alwaysInlineTitle ? .inline : .automatic)
        .navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(isModalPresentation: false)
            .environmentObject(SettingsViewModel())
    }
}
