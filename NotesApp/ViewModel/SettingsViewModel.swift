//
//  SettingsViewModel.swift
//  NotesApp
//
//  Created by Никита Куприянов on 19.08.2023.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    @AppStorage("shouldShowBackgroundAnimation") var shouldShowBackgroundAnimation: Bool = false
    @AppStorage("showSettingsViewUsingModalPresentation") var showSettingsViewModally: Bool = true
    @AppStorage("showAddingViewUsingModalPresentation") var showAddingViewModally: Bool = true
    @AppStorage("isLeftAlignmentOfCancelButton") var isLeftAlignmentOfCancelButton: Bool = true
    @AppStorage("appAccentColor") var appAccentColor: String = "blue"
    @AppStorage("alwaysInlineTitle") var alwaysInlineTitle: Bool = false
    @AppStorage("alwaysClearField") var alwaysClearField: Bool = false
    @AppStorage("isAuth") var isAuth: Bool = false
}
