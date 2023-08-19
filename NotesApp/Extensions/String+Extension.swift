//
//  String+Extension.swift
//  NotesApp
//
//  Created by Никита Куприянов on 13.08.2023.
//

import Foundation
import SwiftUI

extension String {
    func toColor() -> Color {
        switch self {
        case "red": return .red
        case "yellow": return .yellow
        case "mint": return .mint
        case "green": return .green
        case "brown": return .brown
        case "orange": return .orange
        case "blue": return .blue
        case "black": return .black
        default: return .black
        }
    }
}
