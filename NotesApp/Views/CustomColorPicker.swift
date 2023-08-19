//
//  CustomColorPicker.swift
//  NotesApp
//
//  Created by Никита Куприянов on 13.08.2023.
//

import SwiftUI

struct CusTomColorPicker: View {
    @Binding var tagColor: String
    private let tags: [String] = ["red", "yellow", "mint", "green", "brown", "orange"]
    var body: some View {
        HStack {
            ForEach(tags, id: \.hashValue) { tag in
                Circle()
                    .fill(tag.toColor())
                    .frame(width: 35, height: 35)
                    .overlay {
                        if tagColor == tag {
                            Circle()
                                .stroke(Color.primary, style: .init(lineWidth: 2))
                        }
                    }
                    .onTapGesture {
                        withAnimation(.spring()) {
                            self.tagColor = tag
                        }
                    }
            }
        }
    }
}
