//
//  Note.swift
//  NotesApp
//
//  Created by Никита Куприянов on 13.08.2023.
//

import Foundation
import RealmSwift

final class NoteItem: Object, Identifiable { //ObjectKeyIdentifiable
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String = ""
    @Persisted var content: String = ""
    @Persisted var color: String = ""
    @Persisted var timestamp: Date
    
    override class func primaryKey() -> String? {
        "id"
    }
}
